output "lb_arn" {
  value = var.lb_arn
}

output "lambda_arn" {
  value = var.lambda_arn
}

output "target_group_arn" {
  value = aws_lb_target_group.endpoint_tg.arn
}

output "target_group_id" {
  value = aws_lb_target_group.endpoint_tg.id
}

output "target_group_name" {
  value = aws_lb_target_group.endpoint_tg.name
}

output "target_group_arn_suffix" {
  value = aws_lb_target_group.endpoint_tg.arn_suffix
}

output "http_redirect_listener_arn" {
  value = aws_lb_listener.artspot_api_80_http_redirect[0].arn
}

output "http_redirect_listener_id" {
  value = aws_lb_listener.artspot_api_80_http_redirect[0].id
}

output "web_listener_arn" {
  value = var.use_alt_listener_port ? aws_lb_listener.alt_web_listener[0].arn :  aws_lb_listener.web_listener[0].arn
}

output "web_listener_id" {
  value = var.use_alt_listener_port ? aws_lb_listener.alt_web_listener[0].id :  aws_lb_listener.web_listener[0].id
}

output "web_listener_rule_arn" {
  value = aws_lb_listener_rule.endpoint_listener.arn
}

output "web_listener_rule_id" {
  value = aws_lb_listener_rule.endpoint_listener.id
}