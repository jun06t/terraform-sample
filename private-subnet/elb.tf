resource "aws_elb" "dev_elb" {
    name = "dev-elb"
    subnets = [
        "${module.vpc.subnet_public_1a}",
    ]
    security_groups = [
        "${module.security_group.internal_id}",
        "${module.security_group.http_id}",
    ]
    listener {
        instance_port = 80
        instance_protocol = "http"
        lb_port = 80
        lb_protocol = "http"
    }
    health_check {
        healthy_threshold = 2
        unhealthy_threshold = 2
        timeout = 5
        target = "HTTP:80/"
        interval = 30
    }
    instances = ["${aws_instance.dev_api.id}"]
    cross_zone_load_balancing = true
    idle_timeout = 400
    connection_draining = true
    connection_draining_timeout = 400
    tags {
	Environment = "Development"
        Name = "dev-elb"
        Role = "ELB"
    }
}
