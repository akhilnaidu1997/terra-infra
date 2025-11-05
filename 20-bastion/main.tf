resource "aws_instance" "example" {
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id     = local.public_subnet[0]
  vpc_security_group_ids = [ data.aws_ssm_parameter.bastion_sg.value ]


  tags = merge(
    local.common_tags,{
        Name = local.common_name
    }
  )
}