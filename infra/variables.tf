variable "region" {
   type = string
   description = "AWS default region"
   default     = "us-east-1"
}

# availability zones
variable "azs" {
  type = list(string)
  description = "availability zones"
  default     = [ "us-east-1a", "us-east-1b" ]
}

# cluster name
variable "cluster_name" {
  type = string
  description = "ECS cluster name"
  default     = "test"
}
