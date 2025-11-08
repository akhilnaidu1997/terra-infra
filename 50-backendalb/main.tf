resource "aws_lb" "backend" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [local.sg_id]
  subnets            = local.private_subnets

  enable_deletion_protection = false

  tags = merge(
    var.alb_tags,
    local.common_tags,{
        Name = local.common_name
    }
  )
}

resource "aws_lb_listener" "backend_end" {
  load_balancer_arn = aws_lb.backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

resource "aws_route53_record" "backend_alb" {
  zone_id = local.zone_id
  name    = "*.backend-alb-${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_lb.backend.dns_name
    zone_id                = local.zone_id
    evaluate_target_health = true
  }
}