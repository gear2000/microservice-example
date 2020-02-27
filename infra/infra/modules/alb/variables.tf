variable "security_groups" {
   type = list
   description = "Security groups"
}

variable "subnets" {
   type = list
   description = "Subnets"
}

variable "vpc_id" {
   type = string
   description = "VPC ID"
}

