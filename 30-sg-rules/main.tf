resource "aws_security_group_rule" "bastion-alb" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.backend_alb_id
  source_security_group_id =local.bastion
}

resource "aws_security_group_rule" "bastion" {
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.bastion
  cidr_blocks = [ "0.0.0.0/0" ]
}

resource "aws_security_group_rule" "mongodb-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.mongodb
  source_security_group_id =local.bastion
}

resource "aws_security_group_rule" "redis-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.redis
  source_security_group_id =local.bastion
}
resource "aws_security_group_rule" "rabbitmq-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.rabbitmq
  source_security_group_id =local.bastion
}
resource "aws_security_group_rule" "mysql-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.mysql
  source_security_group_id =local.bastion
}

resource "aws_security_group_rule" "catalogue-bastion" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.catalogue
  source_security_group_id =local.bastion
}

resource "aws_security_group_rule" "catalogue-backendalb" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.catalogue
  source_security_group_id =local.backend_alb_id
}