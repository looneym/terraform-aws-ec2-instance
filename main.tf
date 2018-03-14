###############################################################
#
#  CONFIG
#
###############################################################

provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "${var.shared_credentials_file}"
  profile                 = "${var.profile}"
}

###############################################################
#
#  KEY PAIR
#
###############################################################

module "key_pair" {
  source                = "key-pair"
  name                  = "${var.key_pair["name"]}"
  ssh_public_key_location   = "${var.key_pair["ssh_public_key_location"]}"
  generate_ssh_key      = "${var.key_pair["generate_ssh_key"]}"
  private_key_extension = ".pem"
  public_key_extension  = ".pub"
}

###############################################################
#
#  EC2
#
###############################################################

resource "aws_instance" "web01" {
    ami = "${var.ami}"
    instance_type = "${var.instance_type}"
    subnet_id = "${aws_subnet.easy-ec2-subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.easy-ec2-web_server.id}","${aws_security_group.easy-ec2-allow_ssh.id}"]
    key_name = "${var.key_pair["name"]}"
    depends_on = ["module.key_pair"]
}


###############################################################
#
#  VPC
#
###############################################################

resource "aws_vpc" "easy-ec2-vpc" {
  cidr_block = "10.100.0.0/16"   
}

resource "aws_route_table" "easy-ec2-rtb" {
  vpc_id = "${aws_vpc.easy-ec2-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.easy-ec2-gw.id}"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id = "${aws_vpc.easy-ec2-vpc.id}"
  route_table_id = "${aws_route_table.easy-ec2-rtb.id}"
}

resource "aws_internet_gateway" "easy-ec2-gw" {
    vpc_id = "${aws_vpc.easy-ec2-vpc.id}"
}

###############################################################
#
#  SECURITY GROUPS
#
###############################################################

resource "aws_security_group" "easy-ec2-allow_ssh" {
  name = "allow_all"
  description = "Allow inbound SSH traffic from my IP"
  vpc_id = "${aws_vpc.easy-ec2-vpc.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "easy-ec2-web_server" {
  name = "web server"
  description = "Allow HTTP and HTTPS traffic in, browser access out."
  vpc_id = "${aws_vpc.easy-ec2-vpc.id}"

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

###############################################################
#
#  SUBNETS
#
###############################################################

resource "aws_subnet" "easy-ec2-subnet" {
  vpc_id                  = "${aws_vpc.easy-ec2-vpc.id}"
  availability_zone = "${var.availability_zone}"
  cidr_block              = "10.100.2.0/24"
  map_public_ip_on_launch = true
}


###############################################################
#
#  VARIABLES
#
###############################################################


variable "profile" {}

variable "shared_credentials_file" {
  default = "~/.aws/credentials"
}

variable "region" {
  default = "us-east-1"
}

variable "availability_zone" {
  default = "us-east-1b"
}

variable "ami" {
  default = "ami-408c7f28"
}

variable "instance_type" {
  default = "t1.micro"
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

###############################################################
#
#  OUTPUTS
#
###############################################################

output "ip" {
  value = "${aws_instance.web01.public_ip}"
}

output "key_file_with_path" {
  value = "${module.key_pair.key_file_with_path}"
}

