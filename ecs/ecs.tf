resource "aws_ecs_cluster" "api_cluster" {
    name = "api-cluster"
}

resource "aws_ecs_service" "api" {
    name = "api"
    cluster = "${aws_ecs_cluster.api_cluster.id}"
    task_definition = "${aws_ecs_task_definition.api.arn}"
    desired_count = 1
    iam_role = "${aws_iam_role.ecs_service_role.arn}"
    depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]
    load_balancer {
        elb_name = "${aws_elb.dev_elb.name}"
        container_name = "nginx"
        container_port = 80
    }
}

resource "aws_ecs_task_definition" "api" {
    family = "api"
    container_definitions = "${file("task-definitions/api.json")}"
}
