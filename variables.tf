variable "profile" {}

variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "region" {
  default = "us-east-1"
}

variable "key_pair" {
  type    = "map"
  default = {
    "name" = "easy-ec2"
    "stage" = "dev"
    "namespace" = "easy-ec2"
    "ssh_public_key_location" = "~/.ssh/"
    "generate_ssh_key" = "true"
  }
}

