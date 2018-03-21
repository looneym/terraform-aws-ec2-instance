variable "name" {}

variable "delimiter" {
  default = "-"
}

variable "attributes" {
  type    = "list"
  default = []
}

variable "ssh_public_key_location" {
  description = "Path to Read/Write SSH Public Key File (directory, supports path expansion)"
  default = "~/.ssh/"
}

variable "generate_ssh_key" {
  default = "false"
}

variable "ssh_key_algorithm" {
  default = "RSA"
}

variable "private_key_extension" {
  default = ".pem"
}

variable "public_key_extension" {
  default = ".pub"
}
