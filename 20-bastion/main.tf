resource "aws_instance" "example" {
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id     = local.public_subnet[0]
  vpc_security_group_ids = [ data.aws_ssm_parameter.bastion_sg.value ]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data = file("bastion.sh")

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    delete_on_termination = true
    encrypted = true
  }

  tags = merge(
    local.common_tags,{
        Name = local.common_name
    }
  )
}


resource "aws_iam_role" "ec2_admin_role" {
  name = "ec2-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "admin_access_attach" {
  role       = aws_iam_role.ec2_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-admin-instance-profile"
  role = aws_iam_role.ec2_admin_role.name
  depends_on = [ aws_iam_role_policy_attachment.admin_access_attach ]
}