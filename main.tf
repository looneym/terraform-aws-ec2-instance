###############################################################
#
#  CONFIG
#
###############################################################

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/looneym/.aws/credentials"
  profile                 = "default"
}

###############################################################
#
#  EC2
#
###############################################################

resource "aws_instance" "web01" {
    ami = "ami-408c7f28"
    instance_type = "t1.micro"
    subnet_id = "${aws_subnet.web_subnet.id}"
    vpc_security_group_ids = ["${aws_security_group.web_server.id}","${aws_security_group.allow_ssh.id}"]
    key_name = "sobotka"
    tags {
        Name = "web01"
    }
}


###############################################################
#
#  VPC
#
###############################################################

resource "aws_vpc" "myapp" {
  cidr_block = "10.100.0.0/16"   
}

resource "aws_route_table" "r" {
  vpc_id = "${aws_vpc.myapp.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id = "${aws_vpc.myapp.id}"
  route_table_id = "${aws_route_table.r.id}"
}

resource "aws_internet_gateway" "gw" {
    vpc_id = "${aws_vpc.myapp.id}"

    tags {
        Name = "myapp gw"
    }
}

###############################################################
#
#  SECURITY GROUPS
#
###############################################################

resource "aws_security_group" "allow_ssh" {
  name = "allow_all"
  description = "Allow inbound SSH traffic from my IP"
  vpc_id = "${aws_vpc.myapp.id}"

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Allow SSH"
  }
}

resource "aws_security_group" "web_server" {
  name = "web server"
  description = "Allow HTTP and HTTPS traffic in, browser access out."
  vpc_id = "${aws_vpc.myapp.id}"

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

resource "aws_subnet" "web_subnet" {
  vpc_id                  = "${aws_vpc.myapp.id}"
  availability_zone = "us-east-1b"
  cidr_block              = "10.100.2.0/24"
  map_public_ip_on_launch = true

  tags {
    Name = "tf_test_subnet"
  }
}

