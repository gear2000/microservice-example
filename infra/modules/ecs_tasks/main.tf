resource "aws_ecs_task_definition" "test" {

  family = "ms-testing"

  container_definitions = <<DEFINITION
[
  {
    "name": "app-get",
    "image": "williaumwu/ms-app:get",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8081,
        "hostPort": 8081
      }
    ],
    "memory": 256,
    "cpu": 10
  },
  {
    "name": "app-post",
    "image": "williaumwu/ms-app:post",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8080,
        "hostPort": 8080
      }
    ],
    "memory": 256,
    "cpu": 10
  }
]
DEFINITION
}

resource "aws_ecs_service" "test" {
  name            = "ms-testing"
  cluster         =  var.cluster_name
  task_definition = "${aws_ecs_task_definition.test.family}:${aws_ecs_task_definition.test.revision}"

  desired_count   = 2

  load_balancer {
    target_group_arn  = var.target_group_arn
    container_port    = 80
    container_name    = "ms_sample"
  }
}
