resource "aws_ecs_cluster" "api_cluster" {
  name = "api-cluster"
}

resource "aws_ecs_service" "api_service" {
  name                               = "api-service"
  cluster                            = "${aws_ecs_cluster.api_cluster.id}"
  task_definition                    = "${aws_ecs_task_definition.api.arn}"
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 100
  iam_role                           = "${aws_iam_role.ecs_service_role.arn}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.dev_api.arn}"
    container_name   = "nginx"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "api" {
  family                = "api"
  container_definitions = "${file("task-definitions/api.json")}"
}

