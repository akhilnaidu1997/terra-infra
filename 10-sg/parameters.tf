resource "aws_ssm_parameter" "security_groups" {
  count = length(var.sg_name)
  name  = "${var.project}-${var.environment}-${var.sg_name[count.index]}"
  type  = "String"
  value = module.sg[count.index].sg_id
}