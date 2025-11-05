data "aws_ssm_parameter" "sg_id" {
  name = "${var.project}-${var.environment}-backend-alb"
}
data "aws_ssm_parameter" "private_subnets" {
  name = "${var.project}-${var.environment}-private"
}
