data "aws_ami" "ami" {
  most_recent      = true
  owners           = ["973714476881"]

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
data "aws_ssm_parameter" "catalogue" {
  name = "${var.project}-${var.environment}-catalogue"
}
data "aws_ssm_parameter" "private_subnets" {
  name = "${var.project}-${var.environment}-private"
}
data "aws_ssm_parameter" "vpc_id" {
  name = "${var.project}-${var.environment}-vpc-id"
}
data "aws_ssm_parameter" "listener_arn" {
  name = "/${var.project}/${var.environment}/listener_arn"
}