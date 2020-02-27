resource "aws_ecs_service" "ad-app" {
  name            = "ad-app"
  cluster         = aws_ecs_cluster.ad.id
  task_definition = aws_ecs_task_definition.ad-app.arn
  desired_count   = 4
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "ad-app"
    container_port   = "80"
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

resource "aws_ecs_task_definition" "ad-app" {
  family = "ad-app"

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
    "name": "ad-app",
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-ad/ad-app",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "ecs"
      }
    }
  }
]
EOF

}

resource "aws_cloudwatch_log_group" "ad-app" {
  name = "/ecs-ad/ad-app"
}

