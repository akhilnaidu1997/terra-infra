resource "aws_instance" "mongodb" {
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id =  local.database[0]
  vpc_security_group_ids = [ local.mongodb ]

  tags = merge(
    local.common_tags,{
        Name = "${local.common_name}-mongodb"
    }
  )
}

resource "terraform_data" "mongodb" {
    triggers_replace = [
        aws_instance.mongodb.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mongodb.private_ip
   }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mongodb"
         ] 
    }

}

resource "aws_instance" "redis" {
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id =  local.database[0]
  vpc_security_group_ids = [ local.redis ]

  tags = merge(
    local.common_tags,{
        Name = "${local.common_name}-redis"
    }
  )
}

resource "terraform_data" "redis" {
    triggers_replace = [
        aws_instance.redis.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.redis.private_ip
   }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh redis"
         ] 
    }
}

resource "aws_instance" "rabbitmq" {
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id =  local.database[0]
  vpc_security_group_ids = [ local.rabbitmq ]

  tags = merge(
    local.common_tags,{
        Name = "${local.common_name}-rabbitmq"
    }
  )
}

resource "terraform_data" "rabbitmq" {
    triggers_replace = [
        aws_instance.rabbitmq.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.rabbitmq.private_ip
   }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh rabbitmq"
         ] 
    }
}

resource "aws_instance" "mysql" {
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id =  local.database[0]
  vpc_security_group_ids = [ local.mysql ]
  iam_instance_profile = aws_iam_instance_profile.ec2_ssm_profile.name


  tags = merge(
    local.common_tags,{
        Name = "${local.common_name}-mysql"
    }
  )
}

resource "terraform_data" "mysql" {
    triggers_replace = [
        aws_instance.mysql.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.mysql.private_ip
   }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh mysql dev"
         ] 
    }
}

resource "aws_iam_role" "ec2_ssm_role" {
  name = "ec2-ssm-access-role"

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

resource "aws_iam_policy" "ssm_access_policy" {
  name        = "ssm-parameter-access-policy"
  description = "Allow EC2 to read SSM parameters (including SecureString)"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = aws_iam_policy.ssm_access_policy.arn
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "ec2-ssm-instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
  depends_on = [ aws_iam_role_policy_attachment.ssm_attach ]
}