output "ip" {
  value = "${module.ec2.public_ip}"
}

output "key_file_with_path" {
  value = "${module.key_pair.key_file_with_path}"
}

