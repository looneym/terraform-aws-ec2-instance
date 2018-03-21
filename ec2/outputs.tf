output "public_ip" {
  value = "${aws_instance.web01.public_ip}"
}
