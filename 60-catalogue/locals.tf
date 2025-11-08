locals {
  common_tags = {
    project = var.project
    environment = var.environment
    Terraform = "True"
  }
  common_name = "${var.project}-${var.environment}"
  ami = data.aws_ami.ami.id
  private = split(",",data.aws_ssm_parameter.private_subnets.value)
  catalogue = data.aws_ssm_parameter.catalogue.value
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  listener_arn = data.aws_ssm_parameter.listener_arn.value
}