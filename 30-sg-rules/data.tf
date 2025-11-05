data "aws_ssm_parameter" "sg_id" {
  name = "${var.project}-${var.environment}-bastion"
}
data "aws_ssm_parameter" "backend_alb_id" {
  name = "${var.project}-${var.environment}-backend-alb"
}
data "aws_ssm_parameter" "mongodb" {
  name = "${var.project}-${var.environment}-mongodb"
}