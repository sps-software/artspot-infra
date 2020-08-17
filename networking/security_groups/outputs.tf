output "artspot_alb_tls_security_group" {
  value = aws_security_group.allow_tls_lb.id
}

output "ingress_443_private_subnets" {
  value = aws_security_group.vpc_endpoint_private_subnets_443.id
}

output "vpc_endpoint_sns" {
  value = aws_security_group.vpc_endpoint_sns.id
}