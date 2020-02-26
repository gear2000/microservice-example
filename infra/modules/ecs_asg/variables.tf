variable "security_groups" {
   type = list
   description = "Security groups"
}

variable "subnets" {
   type = list
   description = "Subnets"
}

variable "key_pair_name" {
   type = string
   default = "default"
   description = "key pair name"
}

variable "image_id" {
   type = string
   default = "ami-fad25980"
   description = "Image ID"
}

variable "max_instance_size" {
   type = number
   default = 2
   description = "Max Instance Size"
}

variable "min_instance_size" {
   type = number
   default = 1
   description = "Min Instance Size"
}

variable "desired_capacity" {
   type = number
   default = 1
   description = "Desired Capacity"
}
