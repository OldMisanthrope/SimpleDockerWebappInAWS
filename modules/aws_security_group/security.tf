# Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow_web"
  description = "Allow inbound traffic on port 80 and all outbound traffic"
  tags = {
    Name = "allow_web"
  }
}


#Define the ports to be configured in the security group.
locals {
  allowed_ports = ["80"]
}

resource "aws_vpc_security_group_ingress_rule" "allow_ports" {
  for_each          = toset(local.allowed_ports)
  security_group_id = aws_security_group.allow_web.id
  from_port         = each.value
  ip_protocol       = "tcp"
  to_port           = each.value
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
