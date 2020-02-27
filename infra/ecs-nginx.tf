resource "aws_ecs_service" "ad_app" {
  name            = "ad_app"
  cluster         = aws_ecs_cluster.ad.id
  task_definition = aws_ecs_task_definition.ad_app.arn
  desired_count   = 4
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

  load_balancer {
    target_group_arn = aws_alb_target_group.ad_app.id
    container_name   = "ad_app"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "ad_app" {
  family = "ad_app"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 0,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "cpu": 256,
    "memory": 300,
    "image": "nginx:latest",
    "essential": true,
    "name": "ad_app",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-ad/ad_app",
        "awslogs-region": "us-west-1",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF

}

resource "aws_cloudwatch_log_group" "ad_app" {
  name = "/ecs-ad/ad_app"
}

