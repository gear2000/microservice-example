resource "aws_ecs_task_definition" "ms_sample" {
  family                = "ms_sample"
  container_definitions = "${file("./modules/ecs_tasks/task-definitions/service.json")}"
}

resource "aws_ecs_service" "ms_sample-ecs-service" {
  name            = "ms_sample-ecs-service"
  cluster         =  var.cluster_name
  task_definition = "${aws_ecs_task_definition.ms_sample.family}:desired_count${max("${aws_ecs_task_definition.ms_sample.revision}", "${data.aws_ecs_task_definition.ms_sample.revision}")}"

  desired_count   = 2

  load_balancer {
    target_group_arn  = var.target_group_arn
    container_port    = 80
    container_name    = "ms_sample"
  }
}
