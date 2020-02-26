provider "aws" {
 profile    = "default"
 region  = "us-east-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b" ]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
    App = "ms"
  }
}

module "web_sg" {
  source = "./modules/web_sg"
  vpc_id = module.vpc.vpc_id
}

module "web_alb" {
  source = "./modules/web_alb"
  vpc_id = module.vpc.vpc_id
  security_groups    = ["${module.web_sg.sg_id}"]
  subnets            = ["${module.vpc.public_subnets[0]}","${module.vpc.public_subnets[1]}"]
}

module "ecs_asg" {
  source = "./modules/ecs_asg"
  security_groups    = ["${module.web_sg.sg_id}"]
  subnets            = ["${module.vpc.public_subnets[0]}","${module.vpc.public_subnets[1]}"]
  iam_role   = "${aws_iam_instance_profile.ecs-instance-profile.id}"
  iam_role   = "${module.iam_roles.iam_instance_profile_id}"
}

module "iam_roles" {
  source = "./modules/iam_roles"
}

module "ecs_tasks" {
  source = "./modules/ecs_tasks"
  cluster_name = "${aws_ecs_cluster.ecs-cluster.name}"
  target_group_arn  = "${module.web_alb.alb_arn}"
  iam_role          = "${module.iam_roles.iam_service_role_name}"
}

resource "aws_ecs_cluster" "ecs-cluster" {
    name = var.cluster_name
}
