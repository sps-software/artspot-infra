output "lb_id" {
  value = module.alb.id
}

output "lb_arn" {
  value = module.alb.arn
}

output "lb_arn_suffix" {
  value = module.alb.arn_suffix
}

output "lb_dns_name" {
  value = module.alb.dns_name
}

output "lb_zone_id" {
  value = module.alb.zone_id
}

output "cancelation_function_arn" {
  value = data.aws_ssm_parameter.cancelation_api_lambda_arn.value
}

output "cancelation_endpoint_tg_arn" {
  value = module.cancel_membership_endpoint.target_group_arn
}

output "cancelation_endpoint_tg_id" {
  value = module.cancel_membership_endpoint.target_group_id
}

output "cancelation_endpoint_tg_name" {
  value = module.cancel_membership_endpoint.target_group_name
}

output "cancelation_endpoint_tg_arn_suffix" {
  value = module.cancel_membership_endpoint.target_group_arn_suffix
}

output "cancelation_http_redirect_listener_arn" {
  value = module.cancel_membership_endpoint.http_redirect_listener_arn
}

output "cancelation_http_redirect_listener_id" {
  value = module.cancel_membership_endpoint.http_redirect_listener_id
}

output "cancelation_web_listener_arn" {
  value = module.cancel_membership_endpoint.web_listener_arn
}

output "cancelation_web_listener_id" {
  value = module.cancel_membership_endpoint.web_listener_id
}

output "cancelation_web_listener_rule_arn" {
  value = module.cancel_membership_endpoint.web_listener_rule_arn
}

output "cancelation_web_listener_rule_id" {
  value = module.cancel_membership_endpoint.web_listener_rule_id
}