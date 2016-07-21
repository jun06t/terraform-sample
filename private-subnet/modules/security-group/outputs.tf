output "internal_id" {
    value = "${aws_security_group.internal.id}"
}

output "nat_id" {
    value = "${aws_security_group.nat.id}"
}

output "http_id" {
    value = "${aws_security_group.http.id}"
}

output "ssh_id" {
    value = "${aws_security_group.ssh.id}"
}
