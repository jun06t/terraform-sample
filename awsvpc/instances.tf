### Launch configuration
resource "aws_launch_configuration" "test_api" {
  name_prefix                 = "test-api-"
  image_id                    = "${var.amis["ecs"]}"
  instance_type               = "t2.micro"
  iam_instance_profile        = "${aws_iam_instance_profile.ecs.id}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.internal.id}"]
  associate_public_ip_address = 0
  user_data                   = "${file("user_data/api-ecs.sh")}"

  lifecycle {
    create_before_destroy = true
  }
}

### Auto Scaling Group
resource "aws_autoscaling_group" "test_api" {
  availability_zones        = ["ap-northeast-1a"]
  name                      = "test-api"
  max_size                  = 4
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.test_api.id}"
  vpc_zone_identifier       = ["${aws_subnet.private_1a.id}"]

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
    value               = "test-api-asg"
    propagate_at_launch = true
  }

  tag = {
    key                 = "Environment"
    value               = "Test"
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
