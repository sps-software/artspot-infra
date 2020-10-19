output "prod_site_cert_arn" {
  value = aws_acm_certificate.prod_cert.arn
}

output "api_subdomain_cert" {
  value = aws_acm_certificate.api_subdomain_cert.arn
}

output "api_domain_arn" {
  value = aws_acm_certificate.api_domain_cert.arn
}