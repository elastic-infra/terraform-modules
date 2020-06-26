# LB
resource "aws_lb" "redash" {
  name                       = local.base_name
  internal                   = false
  security_groups            = var.lb_security_groups
  subnets                    = var.lb_subnets
  enable_deletion_protection = true
  ip_address_type            = "ipv4"

  dynamic "access_logs" {
    for_each = [var.lb_access_log_bucket]

    content {
      bucket  = access_logs.value
      prefix  = local.base_name
      enabled = true
    }
  }
}

resource "aws_lb_target_group" "redash" {
  name                 = local.base_name
  port                 = 5000
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  deregistration_delay = 30
  target_type          = "ip"

  health_check {
    interval            = "30"
    path                = "/ping"
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.redash.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.redash.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.lb_ssl_policy
  certificate_arn   = var.lb_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.redash.arn
  }
}
