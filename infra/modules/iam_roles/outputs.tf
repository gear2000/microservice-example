output "iam_service_role_name" {
  value = "${aws_iam_role.ecs-service-role.name}"
}

output "iam_instance_profile_id" {
  value = "${aws_iam_instance_profile.ecs-instance-profile.id}"
}
