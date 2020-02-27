# ECS cluster
resource "aws_ecs_cluster" "ad" {
  name = "ad"
}

# Autoscaling groups
resource "aws_autoscaling_group" "ad-cluster" {
  name                      = "ecs-example"
  vpc_zone_identifier       = [aws_subnet.ad-public-1.id, aws_subnet.ad-public-2.id, aws_subnet.ad-public-3.id]
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

    target_value = 40
  }
}

resource "aws_launch_configuration" "launch_configuration" {
  name_prefix     = "launch_configuration"
  security_groups = [aws_security_group.instance_sg.id]

  # key_name                  = "default"
  image_id                    = data.aws_ami.ecs.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.ecs-instance-role.id
  user_data                   = data.template_file.ecs-cluster.rendered
  associate_public_ip_address = true

  lifecycle {
    create_before_destroy = true
  }
}
