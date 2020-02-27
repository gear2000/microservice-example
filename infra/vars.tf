variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-west-1"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

