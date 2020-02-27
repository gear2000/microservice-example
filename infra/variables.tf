variable "region" {
   type = string
   description = "AWS default region"
   default     = "us-east-1"
}

# cluster name
variable "cluster_name" {
  type = string
  description = "ECS cluster name"
  default     = "ad_app"
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance"
}

# availability zones
variable "azs" {
  type = list(string)
  description = "availability zones"
  default     = [ "us-east-1a", "us-east-1b" ]
}

variable "vpc_name" {
  type = string
  description = "vpc name"
  default = "ad_vpc"
}

variable "cidr" {
  type = string
  description = "cidr for vpc"
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type = list(string)
  description = "private subnets"
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  type = list(string)
  description = "public subnets"
  default  = ["10.0.101.0/24", "10.0.102.0/24"]
}