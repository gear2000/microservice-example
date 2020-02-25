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

module "ecs_cluster" {
  source = "infrablocks/ecs-cluster/aws"
  version = "0.2.5"
  
  region  = "us-east-1"
  vpc_id = "${module.vpc.vpc_id}"
  subnet_ids = "${module.vpc.private_subnets[0]}"
  
  component = "important-component"
  deployment_identifier = "production"
  
  cluster_name = "services"
  cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"
  cluster_instance_type = "t2.small"
  
  cluster_minimum_size = 2
  cluster_maximum_size = 10
  cluster_desired_capacity = 4
}

#module.vpc.vpc_cidr_block
