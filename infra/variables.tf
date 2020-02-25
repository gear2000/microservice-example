# main creds for AWS connection
variable "aws_access_key_id" {
  description = "AWS access key"
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS secret access key"
  default     = ""
}

variable "vpc_region" {
  description = "AWS region"
  default     = "us-east-2"
}

# VPC Config
variable "vpc_name" {
  description = "VPC for building demos"
  default     = "pacific"
}

variable "vpc_cidr_block" {
  description = "Uber IP addressing for demo Network"
  default     = "10.0.0.0/16"
}

# Public Subnet Config
variable "subnet_public" {
  description = "Public subnet for VPC"
  default     = "peru"
}

variable "subnet_public_cidr" {
  description = "CIDR for public subnet"
  default     = "10.0.1.0/24"
}

variable "subnet_public_az" {
  description = "Availability zone for public subnet"
  default     = "us-east-2a"
}

# Private Subnet 1 Config
variable "subnet_private_01" {
  description = "Private subnet for demo Network"
  default     = "cali"
}

variable "subnet_private_01_cidr" {
  description = "CIDR for internal subnet"
  default     = "10.0.128.0/24"
}

variable "subnet_private_01_az" {
  description = "Region for private subnet"
  default     = "us-east-2b"
}

# Private Subnet 2 Config
variable "subnet_private_02" {
  description = "Private subnet for demo Network"
  default     = "elnino"
}

variable "subnet_private_02_cidr" {
  description = "CIDR for internal subnet"
  default     = "10.0.129.0/24"
}

variable "subnet_private_02_az" {
  description = "Region for private subnet"
  default     = "us-east-2c"
}

# Nat Config
variable "ami_id_nat" {
  description = "AMI ID for nat instance (different for each region)"

  # This is the NAT AMI for default region: us-east-2
  default = "ami-0f9c61b5a562a16af"
}

variable "instance_type_nat" {
  description = "Instance size for NAT gateway"
  default     = "t2.micro"
}

# Security Groups
variable "sg_internal" {
  description = "Security group for private traffic"
  default     = "internal"
}

variable "sg_public" {
  description = "Security group for public traffic"
  default     = "public"
}
