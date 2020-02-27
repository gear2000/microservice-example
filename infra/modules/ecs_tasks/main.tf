# ecs service role
resource "aws_iam_role" "ecs-service-role" {
  name = "ecs-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "ecs-service-attach" {
  role       = aws_iam_role.ecs-service-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

##############################################################
#
##############################################################

resource "aws_ecs_service" "ad-app" {
  name            = var.cluster_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.ad-app.arn
  desired_count   = 2
  iam_role        = "${aws_iam_role.ecs-service-role.arn}"
  depends_on      = [aws_iam_role_policy_attachment.ecs-service-attach]

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
        "awslogs-region": "us-east-1",
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

