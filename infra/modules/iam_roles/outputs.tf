#output "iam_service_role_arn" {
#  value = "${aws_iam_role.ecs-service-role.arn}"
#}

output "iam_instance_profile_id" {
  value = "${aws_iam_instance_profile.ecs-instance-role.id}"
}
