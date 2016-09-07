resource "aws_ecs_cluster" "api_cluster" {
    name = "api-cluster"
}

resource "aws_ecs_service" "api_service" {
    name = "api-service"
    cluster = "${aws_ecs_cluster.api_cluster.id}"
    task_definition = "${aws_ecs_task_definition.api.arn}"
    desired_count = 1
    deployment_minimum_healthy_percent = 50
    deployment_maximum_percent = 100
    iam_role = "${aws_iam_role.ecs_service_role.arn}"
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

### ECS AutoScaling Alarm
resource "aws_cloudwatch_metric_alarm" "dev_api_service_high" {
    alarm_name = "dev-api-service-CPU-Utilization-High-30"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    namespace = "AWS/ECS"
    period = "300"
    statistic = "Average"
    threshold = "30"
    dimensions {
        ClusterName = "${aws_ecs_cluster.api_cluster.name}"
        ServiceName = "${aws_ecs_service.api_service.name}"
    }
    alarm_actions = ["${aws_appautoscaling_policy.scale_out.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "dev_api_service_low" {
    alarm_name = "dev-api-service-CPU-Utilization-Low-5"
    comparison_operator = "LessThanThreshold"
    evaluation_periods = "1"
    metric_name = "CPUUtilization"
    namespace = "AWS/ECS"
    period = "180"
    statistic = "Average"
    threshold = "5"
    dimensions {
        ClusterName = "${aws_ecs_cluster.api_cluster.name}"
        ServiceName = "${aws_ecs_service.api_service.name}"
    }
    alarm_actions = ["${aws_appautoscaling_policy.scale_in.arn}"]
}


### App AutoScaling Policy
resource "aws_appautoscaling_target" "target" {
    service_namespace = "ecs"
    resource_id = "service/${aws_ecs_cluster.api_cluster.name}/${aws_ecs_service.api_service.name}"
    scalable_dimension = "ecs:service:DesiredCount"
    role_arn = "${aws_iam_role.ecs_autoscale_role.arn}"
    min_capacity = 1
    max_capacity = 2
}

resource "aws_appautoscaling_policy" "scale_out" {
    name = "scale-out"
    resource_id = "service/${aws_ecs_cluster.api_cluster.name}/${aws_ecs_service.api_service.name}"
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    metric_aggregation_type = "Average"
    step_adjustment {
        metric_interval_lower_bound = 0
        scaling_adjustment = 1
    }
    depends_on = ["aws_appautoscaling_target.target"]
}

resource "aws_appautoscaling_policy" "scale_in" {
    name = "scale-in"
    resource_id = "service/${aws_ecs_cluster.api_cluster.name}/${aws_ecs_service.api_service.name}"
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    metric_aggregation_type = "Average"
    step_adjustment {
        metric_interval_upper_bound = 0
        scaling_adjustment = -1
    }
    depends_on = ["aws_appautoscaling_target.target"]
}

