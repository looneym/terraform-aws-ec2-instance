# output "ip" {
#   value = "${aws_instance.web01.public_ip}"
# }

output "key_file_with_path" {
  value = "${module.key_pair.key_file_with_path}"
}

