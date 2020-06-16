locals {
  environment_ext = "${var.environment == "" ? "" : "-"}${var.environment == "" ? "" : var.environment}"
}

resource "aws_lambda_permission" "with_lb" {
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = aws_lb_target_group.endpoint_tg.arn
}

resource "aws_lb_target_group" "endpoint_tg" {
  name     = "cancelation-api${local.environment_ext}"
  port     = var.health_check_port
  protocol = var.health_check_protocol
  target_type = "lambda"
  health_check {
    path = var.health_check_path
    matcher = var.health_check_matcher
    interval = var.health_check_interval
    timeout = var.health_check_timeout
  }

  tags = {
    "environment" = var.environment
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  target_group_arn = aws_lb_target_group.endpoint_tg.arn
  target_id        = var.lambda_arn
  depends_on       = [aws_lambda_permission.with_lb]
}

resource "aws_lb_listener" "artspot_api_80_http_redirect" {
  count = var.https ? 1 : 0
  load_balancer_arn = var.lb_arn
  port              = "80"
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

resource "aws_lb_listener" "web_listener" {
  count = var.use_alt_listener_port ? 0 : 1
  load_balancer_arn = var.lb_arn
  port              = var.https ? "443" : 80
  protocol          = var.https ? "HTTPS" : "HTTP"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.https ? var.cert_arn : null

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener" "alt_web_listener" {
  count = var.use_alt_listener_port ? 1 : 0
  load_balancer_arn = var.lb_arn
  port              = var.alt_listener_port
  protocol          = var.alt_listener_protocol
  ssl_policy        = "ELBSecurityPolicy_2016_08"
  certificate_arn   = var.https ? var.cert_arn : null

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "endpoint_listener" {
  listener_arn = var.use_alt_listener_port ? aws_lb_listener.alt_web_listener[0].arn : aws_lb_listener.web_listener[0].arn
  priority     = var.listener_priority

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.endpoint_tg.arn 
  }

  condition {
    path_pattern {
      values = var.path_patterns
    }
  }
}
