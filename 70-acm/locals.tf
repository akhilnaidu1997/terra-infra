locals {
  common_name = "${var.project}-${var.Environment}"
  common_tags = {
    Project = var.project
    Environment = var.Environment
    Terraform = "True"
  }
  zone = data.aws_route53_zone.zone.zone_id
}