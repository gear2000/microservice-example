variable "cluster_name" {
   type = string
   description = "Cluster name"
}

variable "cluster_id" {
   type = string
   description = "Cluster ID"
}

variable "target_group_arn" {
   type = string
   description = "Target Group Arn"
}

variable "iam_role" {
   type = string
   default = "default"
   description = "iam role"
}
