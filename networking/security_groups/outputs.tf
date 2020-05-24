output "artspot_alb_tls_security_group" {
  value = aws_security_group.allow_tls_lb.id
}