provider "aws" {
  profile = "default"
  version = ">= 2.1"
  region  = var.aws_region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ad-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b" ]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Environment = "dev"
  }
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "iam_roles" {
  source = "./modules/iam_roles"
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  security_groups    = ["${module.security_groups.alb_sg_id}"]
  subnets            = ["${module.vpc.public_subnets[0]}","${module.vpc.public_subnets[1]}"]
  user_data          = data.template_file.ecs-cluster.rendered
  image_id           = data.aws_ami.ecs.id
}

module "ecs_asg" {
  source = "./modules/ecs_asg"
  security_groups    = ["${module.security_groups.instance_sg_id}"]
  subnets            = ["${module.vpc.public_subnets[0]}","${module.vpc.public_subnets[1]}"]
  iam_instance_profile = "${module.iam_roles.iam_instance_profile_id}"
}

resource "aws_ecs_cluster" "ad" {
  name = "ad"
  #name = var.cluster_name
}

module "ecs_tasks" {
  source = "./modules/ecs_tasks"
  cluster_name = "ad_app"
  cluster_id = aws_ecs_cluster.ad.id
  target_group_arn  = "${module.alb.alb_arn}"
  #target_group_arn = aws_alb_target_group.app.id
  iam_role          = "${module.iam_roles.iam_service_role_arn}"
}
