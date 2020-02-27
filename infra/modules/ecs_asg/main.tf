# ecs instance role
resource "aws_iam_role" "ecs-instance-role" {
  name = "ecs-instance-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_instance_profile" "ecs-instance-role" {
  name = "ecs-instance-role"
  role = aws_iam_role.ecs-instance-role.name
}

resource "aws_iam_role_policy" "ecs-instance-role-policy" {
  name = "ecs-instance-role-policy"
  role = aws_iam_role.ecs-instance-role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ecs:CreateCluster",
              "ecs:DeregisterContainerInstance",
              "ecs:DiscoverPollEndpoint",
              "ecs:Poll",
              "ecs:RegisterContainerInstance",
              "ecs:StartTelemetrySession",
              "ecs:Submit*",
              "ecs:StartTask",
              "ecr:GetAuthorizationToken",
              "ecr:BatchCheckLayerAvailability",
              "ecr:GetDownloadUrlForLayer",
              "ecr:BatchGetImage",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF

}

#############################################################
# Autoscaling groups
#############################################################

resource "aws_autoscaling_group" "ad-cluster" {
  name                      = "ecs-example"
  vpc_zone_identifier       = var.subnets
  min_size                  = "2"
  max_size                  = "10"
  desired_capacity          = "2"
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  health_check_grace_period = 120
  default_cooldown          = 30
  termination_policies      = ["OldestInstance"]

  tag {
    key                 = "Name"
    value               = "ad-cluster-asg"
    propagate_at_launch = true
  }
}

# Autoscaling criteria
resource "aws_autoscaling_policy" "ad-cluster" {
  name                      = "ad-ecs-auto-scaling"
  policy_type               = "TargetTrackingScaling"
  estimated_instance_warmup = "90"
  adjustment_type           = "ChangeInCapacity"
  autoscaling_group_name    = aws_autoscaling_group.ad-cluster.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 60
  }
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix     = "launch_configuration"
  security_groups             = var.security_groups
  # key_name                  = "default"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = "${aws_iam_instance_profile.ecs-instance-role.id}"
  #user_data                   = var.user_data
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
