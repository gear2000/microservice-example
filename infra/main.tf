provider "aws" {
 profile    = "default"
 region     = var.region
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
    App = "ms"
  }
}

#module "ecs_cluster" {
#  source = "infrablocks/ecs-cluster/aws"
#  version = "0.2.5"
#  
#  region  = var.region
#  vpc_id = "${aws_vpc.main-vpc.id}"
#
#  subnet_ids = "${aws_subnet.public[0]},${aws_subnet.public[1]},${aws_subnet.private[0]},${aws_subnet.private[1]}"
#  
#  component = "important-component"
#  deployment_identifier = "production"
#  
#  cluster_name = "services"
#  cluster_instance_ssh_public_key_path = "~/.ssh/id_rsa.pub"
#  cluster_instance_type = "t2.small"
#  
#  cluster_minimum_size = 2
#  cluster_maximum_size = 10
#  cluster_desired_capacity = 4
#}
