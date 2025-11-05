locals {
  sg_id = data.aws_ssm_parameter.sg_id.value
  private_subnets = split(",",data.aws_ssm_parameter.private_subnets.value)
  common_tags = {
    project = var.project
    environment = var.environment
  }
  common_name = "${var.project}-${var.environment}-${var.alb_name}"
}