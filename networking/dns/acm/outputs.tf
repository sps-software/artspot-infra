output "prod_site_cert_arn" {
  value = aws_acm_certificate.prod_cert.arn
}

output "staging_site_cert_arn" {
  value = aws_acm_certificate.staging_cert.arn
}

output "prod_api_cert_arn" {
  value = aws_acm_certificate.prod_api_cert.arn
}

output "staging_api_cert_arn" {
  value = aws_acm_certificate.staging_api_cert.arn
}