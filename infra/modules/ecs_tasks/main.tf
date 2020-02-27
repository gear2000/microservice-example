resource "aws_ecs_service" "ad-app" {
  name            = var.cluster_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.ad-app.arn
  desired_count   = 2
  iam_role        = var.iam_role
# depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

  load_balancer {
    target_group_arn = var.target_group_arn
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

