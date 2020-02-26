data "aws_ecs_task_definition" "ms_sample" {
  task_definition = "${aws_ecs_task_definition.ms_sample.family}"
}

resource "aws_ecs_task_definition" "ms_sample" {
    family                = "exam"
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

resource "aws_ecs_service" "ms_sample-ecs-service" {
  name            = "ms_sample-ecs-service"
  cluster         =  var.cluster_name
  task_definition = "${aws_ecs_task_definition.ms_sample.family}:desired_count${max("${aws_ecs_task_definition.ms_sample.revision}", "${data.aws_ecs_task_definition.ms_sample.revision}")}"

  desired_count   = 2

  load_balancer {
    target_group_arn  = var.target_group_arn
    container_definitionser_port    = 80
    container_name    = "ms_sample"
}
}
