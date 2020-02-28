resource "aws_ecs_service" "ad-app" {
  name            = var.cluster_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.ad-app.arn
  desired_count   = 2
  iam_role        = var.iam_role

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "nginx"
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
    "name": "nginx",
    "image": "${var.nginx_image_ref}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80
      }
    ],
    "links": [ "get",
               "post"
    ],
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-ad/ad-app",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "app"
      }
    },
    "memory": 256,
    "cpu": 10
  },
  {
    "name": "get",
    "image": "${var.get_image_ref}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8081,
        "hostPort": 8081
      }
    ],
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-ad/ad-app",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "app"
      }
    },
    "memory": 256,
    "cpu": 10
  },
  {
    "name": "post",
    "image": "${var.post_image_ref}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "logConfiguration": {
    "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs-ad/ad-app",
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "app"
      }
    },
    "memory": 256,
    "memory": 256,
    "cpu": 10
  }
]
EOF
}

# Create cloud watch logs
resource "aws_cloudwatch_log_group" "ad-app" {
  name = "/ecs-ad/ad-app"
}