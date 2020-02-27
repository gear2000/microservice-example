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

variable "nginx_image_ref" {
  default     = "williaumwu/ms-nginx:app"
  description = "Nginx image reference"
}

variable "get_image_ref" {
  default     = "williaumwu/ms-app-get"
  description = "HTTP get image reference"
}

variable "post_image_ref" {
  default     = "williaumwu/ms-app-post"
  description = "HTTP post image reference"
}
