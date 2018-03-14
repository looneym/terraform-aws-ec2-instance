provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "${var.profile}"
}

module "key_pair" {
  source                = "key-pair"
  name                  = "${var.key_pair["name"]}"
  ssh_public_key_location   = "${var.key_pair["ssh_public_key_location"]}"
  generate_ssh_key      = "${var.key_pair["generate_ssh_key"]}"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

module "ec2" {
  source = "ec2"
  key_name = "${var.key_pair["name"]}"
}

module "network" {
  source = "network"
}
