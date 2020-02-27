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

# create private network
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true

}

# create secruity group
module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

# create iam roles
module "iam_roles" {
  source = "./modules/iam_roles"
}

# create application load balancer
module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  security_groups    = ["${module.security_groups.alb_id}"]
  subnets            = ["${module.vpc.public_subnets[0]}","${module.vpc.public_subnets[1]}"]
}

# create autoscaling groups
module "ecs_asg" {
  # The deploy name should change with each new deploy
  # to ensure Terraform rolls the updates
  deploy_name = var.deploy_name
  source = "./modules/ecs_asg"
  security_groups    = ["${module.security_groups.instance_id}"]
  subnets            = ["${module.vpc.public_subnets[0]}","${module.vpc.public_subnets[1]}"]
  iam_instance_profile = "${module.iam_roles.iam_instance_profile_id}"
  image_id           = data.aws_ami.ecs.id
  cluster_name       = var.cluster_name
}

# create ecs cluster
resource "aws_ecs_cluster" "ad" {
  name = var.cluster_name
}

# deploy app
module "ecs_tasks" {
  source = "./modules/ecs_tasks"
  cluster_name = var.cluster_name
  cluster_id = aws_ecs_cluster.ad.id
  target_group_arn  = "${module.alb.arn}"
  iam_role          = "${module.iam_roles.iam_service_role_arn}"
  nginx_image_ref   =  var.nginx_image_ref
}

