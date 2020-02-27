provider "aws" {
  profile = "default"
  version = ">= 2.1"
  region  = var.region
}

# get ECS AMI with owner being "AWS"
data "aws_ami" "ecs" {
  most_recent = true

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["591542846629"] 
}

# ECS cluster info
data "template_file" "ecs-cluster" {
  template = file("ecs-cluster.tpl")

  vars = {
    ecs_cluster = aws_ecs_cluster.ad.name
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ad-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true

  tags = {
    Environment = "dev"
  }
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  security_groups    = ["${module.security_groups.alb_id}"]
  subnets            = ["${module.vpc.public_subnets[0]}","${module.vpc.public_subnets[1]}"]
}

module "ecs_asg" {
  source = "./modules/ecs_asg"
  security_groups    = ["${module.security_groups.instance_id}"]
  subnets            = ["${module.vpc.public_subnets[0]}","${module.vpc.public_subnets[1]}"]
  image_id           = data.aws_ami.ecs.id
  #user_data          = data.template_file.ecs-cluster.rendered
}

resource "aws_ecs_cluster" "ad" {
  name = var.cluster_name
}

module "ecs_tasks" {
  source = "./modules/ecs_tasks"
  cluster_name = var.cluster_name
  cluster_id = aws_ecs_cluster.ad.id
  target_group_arn  = "${module.alb.arn}"
}

