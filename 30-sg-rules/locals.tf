locals {
  backend_alb_id = data.aws_ssm_parameter.backend_alb_id.value
  bastion = data.aws_ssm_parameter.sg_id.value
  mongodb = data.aws_ssm_parameter.mongodb.value
}