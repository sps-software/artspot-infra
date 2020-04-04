resource "aws_acm_certificate" "prod_cert" {
  domain_name = var.prod_domain
  validation_method = "DNS"
}

resource "aws_acm_certificate" "staging_cert" {
  domain_name = var.staging_domain
  validation_method = "DNS"
}