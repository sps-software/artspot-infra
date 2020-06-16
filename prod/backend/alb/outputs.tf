output "id" {
  value = module.alb.id
}

output "arn" {
  value = module.alb.arn
}

output "arn_suffix" {
  value = module.alb.arn_suffix
}

output "dns_name" {
  value = module.alb.dns_name
}

output "zone_id" {
  value = module.alb.zone_id
}

output "listener_arn" {
  value = aws_lb_listener.artspot-api.arn
}