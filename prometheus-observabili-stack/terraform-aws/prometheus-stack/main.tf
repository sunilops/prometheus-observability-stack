terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "security_group" {
  source = "../modules/security-group"

  name        = var.name
  vpc_id      = var.vpc_id
  owner       = var.owner
  environment = var.environment
}

module "ec2" {
  source = "../modules/ec2"

  ami_id             = var.ami_id
  instance_type      = var.instance_type
  key_name           = var.key_name
  instance_count     = var.instance_count
  volume_size        = var.volume_size
  subnet_ids         = var.subnet_ids
  security_group_ids = [module.security_group.security_group_id]
  name               = var.name
  owner              = var.owner
  environment        = var.environment
  cost_center        = var.cost_center
  application        = var.application
}
