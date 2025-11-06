locals {
  common_tags = {
    project = var.project
    environment = var.environment
    Terraform = "True"
  }
  common_name = "${var.project}-${var.environment}"
  ami = data.aws_ami.ami.id
  mongodb = data.aws_ssm_parameter.sg_id.value
  database = split(",",data.aws_ssm_parameter.database_subnets.value)
  redis = data.aws_ssm_parameter.redis.value
  rabbitmq = data.aws_ssm_parameter.rabbitmq.value
  mysql = data.aws_ssm_parameter.mysql.value
}