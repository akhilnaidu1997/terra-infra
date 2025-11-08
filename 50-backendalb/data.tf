data "aws_ssm_parameter" "sg_id" {
  name = "${var.project}-${var.environment}-backend-alb"
}
data "aws_ssm_parameter" "private_subnets" {
  name = "${var.project}-${var.environment}-private"
}
data "aws_route53_zone" "zone" {
  name         = "daws86s-akhil.shop"
  private_zone = false
}