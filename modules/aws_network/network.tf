# Elastic IP (EIP) to bind to the NLB
resource "aws_eip" "nlb_eip" {
  vpc = true
  tags = {
    Name = "Simple Webapp NLB Elastic IP"
  }
}


#Elastic Load Balancer
resource "aws_elb" "load_balancer" {
  name               = "Simple-webserver-Load-Balancer"
  availability_zones = [var.def_subnet_a.availability_zone, var.def_subnet_b.availability_zone]
  security_groups    = [var.security_group_id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 10
  }
  tags = {
    Name = "Simple-webserver-HA-Load-ELB"
  }
}

