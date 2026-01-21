# --- 1. TARGET GROUP ---
resource "aws_lb_target_group" "c2_tg" {
  name        = "c2-alb-target-grp"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.default.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group_attachment" "c2_attachment" {
  target_group_arn = aws_lb_target_group.c2_tg.arn
  target_id        = aws_instance.c2_server.id
  port             = 80
}

# --- 2. LOAD BALANCER ---
resource "aws_lb" "c2_alb" {
  name               = "c2-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = data.aws_subnets.default_subnet.ids
}

# --- 3. LISTENER & RULES ---
resource "aws_lb_listener" "c2_http_listener" {
  load_balancer_arn = aws_lb.c2_alb.arn
  port              = "80"
  protocol          = "HTTP"

  # Default: Return 403 Access Denied (If header is missing)
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "allow_cloudfront_only" {
  listener_arn = aws_lb_listener.c2_http_listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.c2_tg.arn
  }

  condition {
    http_header {
      http_header_name = "X-Custom-Header"
      values           = [var.cloudfront_secret_header]
    }
  }
}
