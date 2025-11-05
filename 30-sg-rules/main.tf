resource "aws_security_group_rule" "bastion-alb" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.backend_alb_id
  source_security_group_id =local.bastion
}

resource "aws_security_group_rule" "mongodb-alb" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  #cidr_blocks       = [aws_vpc.example.cidr_block]
  security_group_id = local.mongodb
  source_security_group_id =local.backend_alb_id
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
