locals {
  ami = data.aws_ami.ami.id 
  public_subnet = split(",",data.aws_ssm_parameter.public_subnet.value)
  common_tags = {
    project = var.project
    environment = var.environment
  }
  common_name = "${var.project}-${var.environment}-bastion"
}