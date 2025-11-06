resource "aws_instance" "catalogue" {
  ami           = local.ami
  instance_type = var.instance_type
  subnet_id =  local.private[0]
  vpc_security_group_ids = [ local.catalogue ]

  tags = merge(
    local.common_tags,{
        Name = "${local.common_name}-catalogue"
    }
  )
}

resource "terraform_data" "catalogue" {
    triggers_replace = [
        aws_instance.catalogue.id
    ]

    connection {
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
    host     = aws_instance.catalogue.private_ip
   }

    provisioner "file" {
        source = "bootstrap.sh"
        destination = "/tmp/bootstrap.sh"
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo chmod +x /tmp/bootstrap.sh",
            "sudo sh /tmp/bootstrap.sh catalogue"
         ] 
    }

}