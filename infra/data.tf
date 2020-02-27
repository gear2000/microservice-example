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

