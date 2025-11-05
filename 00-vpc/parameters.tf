resource "aws_ssm_parameter" "vpc_id" {
  name  = "${var.project}-${var.environment}-vpc-id"
  type  = "String"
  value = module.vpc.vpc_id
}
resource "aws_ssm_parameter" "public" {
  name  = "${var.project}-${var.environment}-public"
  type  = "String"
  value = join(",",module.vpc.public_subnets)
}

resource "aws_ssm_parameter" "private" {
  name  = "${var.project}-${var.environment}-private"
  type  = "String"
  value = join(",",module.vpc.private_subnets)
}

resource "aws_ssm_parameter" "database" {
  name  = "${var.project}-${var.environment}-database"
  type  = "String"
  value = join(",",module.vpc.database_subnets)
}

