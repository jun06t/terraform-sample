resource "aws_alb" "dev_api" {
  name = "dev-api"

  subnets = [
    "${aws_subnet.public_1a.id}",
  ]

  security_groups = [
    "${aws_security_group.internal.id}",
    "${aws_security_group.http.id}",
  ]

  internal                   = false
  enable_deletion_protection = false

  tags {
    Name        = "dev-alb"
    Environment = "Development"
    Type        = "ALB"
  }
}

resource "aws_alb_target_group" "dev_api" {
  name                 = "dev-api"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = "${aws_vpc.vpc.id}"
  deregistration_delay = 30

  health_check {
    interval            = 30
    path                = "/alive"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 4
    matcher             = 200
  }

  tags {
    Name        = "dev-alb"
    Environment = "Development"
    Type        = "ALB"
  }
}

resource "aws_alb_listener" "dev_api" {
  load_balancer_arn = "${aws_alb.dev_api.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.dev_api.arn}"
    type             = "forward"
  }
}
