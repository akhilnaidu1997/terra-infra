locals {
  common_tags = {
    project = var.project
    environment = var.environment
    Terraform = "True"
  }
  common_name = "${var.project}-${var.environment}-mongodb"
  ami = data.aws_ami.ami.id
  mongodb = data.aws_ssm_parameter.sg_id.value
  database = split(",",data.aws_ssm_parameter.database_subnets.value)
}