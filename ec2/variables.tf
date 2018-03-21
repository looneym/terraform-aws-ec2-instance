variable "ami" {
  default = "ami-408c7f28"
}

variable "instance_type" {
  default = "t1.micro"
}

variable "subnet_id" {}
variable "vpc_security_group_ids" {
  type = "list"
}
variable "key_name" {}
