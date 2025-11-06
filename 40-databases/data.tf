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
data "aws_ssm_parameter" "sg_id" {
  name = "${var.project}-${var.environment}-mongodb"
}
data "aws_ssm_parameter" "database_subnets" {
  name = "${var.project}-${var.environment}-database"
}
data "aws_ssm_parameter" "redis" {
  name = "${var.project}-${var.environment}-redis"
}
data "aws_ssm_parameter" "rabbitmq" {
  name = "${var.project}-${var.environment}-rabbitmq"
}
data "aws_ssm_parameter" "mysql" {
  name = "${var.project}-${var.environment}-mysql"
}

data "aws_route53_zone" "zone" {
  name         = "daws86s-akhil.shop"
  private_zone = false
}