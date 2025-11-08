locals {
  backend_alb_id = data.aws_ssm_parameter.backend_alb_id.value
  bastion = data.aws_ssm_parameter.sg_id.value
  mongodb = data.aws_ssm_parameter.mongodb.value
  redis = data.aws_ssm_parameter.redis.value
  rabbitmq = data.aws_ssm_parameter.rabbitmq.value
  mysql = data.aws_ssm_parameter.mysql.value
  catalogue = data.aws_ssm_parameter.catalogue.value
  frontend = data.aws_ssm_parameter.frontend.value
}