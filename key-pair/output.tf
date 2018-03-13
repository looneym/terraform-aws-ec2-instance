output "key_name" {
  value = "${element(compact(concat(aws_key_pair.imported.*.key_name, aws_key_pair.generated.*.key_name)), 0)}"
}

output "public_key" {
  value = "${join("", tls_private_key.default.*.public_key_openssh)}"
}

output "key_file_with_path" {
  value = "${var.ssh_public_key_location}${var.name}${var.private_key_extension}"
}
