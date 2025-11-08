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
            "sudo sh /tmp/bootstrap.sh catalogue ${var.environment}"
         ] 
    }

}

resource "aws_ec2_instance_state" "stop_instance" {
instance_id = aws_instance.catalogue.id
state = "stopped"
depends_on = [ terraform_data.catalogue ]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${var.project}-${var.environment}-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.stop_instance ]
  tags = merge(
    local.common_tags,{
        Name = "${local.common_name}-catalogue"
    }
  )
}

resource "aws_launch_template" "catalogue" {
  name = "catalogue-template"
  image_id = aws_ami_from_instance.catalogue.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [local.catalogue]
  

  tag_specifications {
    resource_type = "instance"

    tags = merge(
    local.common_tags,{
        Name = "${local.common_name}-catalogue-template"
    }
  )
  }
}

resource "aws_lb_target_group" "health_check_catalogue" {
 name = "${var.project}-${var.environment}-tg"
 port = 8080
 protocol = "HTTP"
 vpc_id = local.vpc_id
 deregistration_delay = 100
 target_type = "instance"
 health_check {
   enabled = true
   interval = 10
   path = "/health"
   protocol = "HTTP"
   timeout = 5
   healthy_threshold = 3
   unhealthy_threshold = 3
   matcher = "200-299"
 }
}

resource "aws_lb_listener_rule" "backend_alb_rule" {
  listener_arn = local.listener_arn
  priority     = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.health_check_catalogue.arn
  }

  condition {
    host_header {
      values = ["catalogue.backend-alb-${var.environment}.${var.domain_name}"]
    }
  }
}

resource "aws_autoscaling_group" "bar" {
  name                      = "${var.project}-${var.environment}-ASG"
  max_size                  = 10
  min_size                  = 1
  health_check_grace_period = 100
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  launch_template {
    id      = aws_launch_template.catalogue.id
    version = "$Latest"
  }
  vpc_zone_identifier       = [local.private[0],local.private[1]]


  dynamic "tag" {
    for_each = merge(
    local.common_tags,{
        Name = "${local.common_name}-catalogue"
    }
  )
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  timeouts {
    delete = "15m"
  }

}

resource "aws_autoscaling_policy" "backend" {
  name                   = "${var.project}-${var.environment}"
  scaling_adjustment     = 2
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.bar.name
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 75.0
  }
}