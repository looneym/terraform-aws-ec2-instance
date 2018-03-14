resource "aws_instance" "web01" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${aws_subnet.easy-ec2-subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.easy-ec2-web_server.id}","${aws_security_group.easy-ec2-allow_ssh.id}"]
    key_name = "${var.key_name}"
    depends_on = ["module.key_pair"]
}
