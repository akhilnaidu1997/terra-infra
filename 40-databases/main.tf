resource "aws_instance" "mongodb" {
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id =  local.database[0]
  vpc_security_group_ids = [ local.mongodb ]

  tags = merge(
    local.common_tags,{
        Name = local.common_name
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
            "sudo sh /tmp/bootstrap.sh redis"
         ] 
    }

}