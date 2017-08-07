# Launch configuration
resource "aws_launch_configuration" "dev_api" {
  name_prefix                 = "dev-api-"
  image_id                    = "${var.amis.api}"
  instance_type               = "t2.micro"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.internal.id}"]
  associate_public_ip_address = 0

  lifecycle {
    create_before_destroy = true
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "dev_api" {
  availability_zones        = ["ap-northeast-1a"]
  name                      = "dev-api"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.dev_api.id}"
  vpc_zone_identifier       = ["${aws_subnet.private_1a.id}"]
  load_balancers            = ["${aws_elb.dev_elb.name}"]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]

  tag = {
    key                 = "Name"
    value               = "dev-api-asg"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Environment"
    value               = "Development"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Type"
    value               = "API"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "dev_api_scale_out" {
  name                   = "Instance-ScaleOut-CPU-High"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.dev_api.name}"
}

resource "aws_cloudwatch_metric_alarm" "dev_api_high" {
  alarm_name          = "dev-api-CPU-Utilization-High-30"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "30"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.dev_api.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.dev_api_scale_out.arn}"]
}

resource "aws_autoscaling_policy" "dev_api_scale_in" {
  name                   = "Instance-ScaleIn-CPU-Low"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.dev_api.name}"
}

resource "aws_cloudwatch_metric_alarm" "dev_api_low" {
  alarm_name          = "dev-api-CPU-Utilization-Low-5"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Average"
  threshold           = "5"

  dimensions {
    AutoScalingGroupName = "${aws_autoscaling_group.dev_api.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.dev_api_scale_in.arn}"]
}
