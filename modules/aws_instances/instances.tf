

#Determine the AMI of the Ubuntu24 image we need in the selected region
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}


#Launch Template for creating Instance with Docker & Dockercompose, and other software specified in the user-data
resource "aws_launch_template" "simple_site" {
  name                   = "Simple-webserver-configuration"
  image_id               = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.ssh_key
  vpc_security_group_ids = [var.security_group_id]
  user_data              = base64encode(file("user_data.sh"))

  lifecycle {
    create_before_destroy = true
  }
}


#Auto scaling group to run High Avaliability application.
resource "aws_autoscaling_group" "simple_site_sg" {
  name = "Simple-webserver-ASG"
  launch_template {
    id      = aws_launch_template.simple_site.id
    version = "$Latest"
  }
  min_size            = 2
  max_size            = 2
  min_elb_capacity    = 2
  vpc_zone_identifier = [var.def_subnet_a.id, var.def_subnet_b.id]
  health_check_type   = "ELB"
  load_balancers      = [var.load_balancer_name]

  dynamic "tag" {
    for_each = {
      Name  = "Simple Webserver in ASG"
      Owner = "Mahabharata"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}
