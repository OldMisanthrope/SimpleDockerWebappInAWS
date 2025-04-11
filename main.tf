provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  region                   = var.region
}

terraform {
  backend "s3" {
    bucket = "others-remote-state-bucket"
    key    = "terraform/simple_docker_webapp/state"
    region = "eu-north-1"
  }
}


#Determine the available zones in the selected region
data "aws_availability_zones" "available_az" {}

resource "aws_default_subnet" "def_subnet_a" {
  availability_zone = data.aws_availability_zones.available_az.names[0]
}

resource "aws_default_subnet" "def_subnet_b" {
  availability_zone = data.aws_availability_zones.available_az.names[1]
}


module "aws_instances" {
  source             = "./modules/aws_instances"
  ssh_key            = var.key
  load_balancer_id   = module.aws_network.load_balancer_id
  security_group_id  = module.security_group.security_group_id
  load_balancer_name = module.aws_network.load_balancer_name
  def_subnet_a       = aws_default_subnet.def_subnet_a
  def_subnet_b       = aws_default_subnet.def_subnet_b
}

module "aws_network" {
  source            = "./modules/aws_network"
  security_group_id = module.security_group.security_group_id
  def_subnet_a      = aws_default_subnet.def_subnet_a
  def_subnet_b      = aws_default_subnet.def_subnet_b
}

module "security_group" {
  source = "./modules/aws_security_group"
}













