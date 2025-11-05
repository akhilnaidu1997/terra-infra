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
data "aws_ssm_parameter" "public_subnet" {
  name = "${var.project}-${var.environment}-public"
}

data "aws_ssm_parameter" "bastion_sg" {
  name = "${var.project}-${var.environment}-bastion"
}
