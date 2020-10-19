#landing page (and also app currently)
resource "aws_acm_certificate" "prod_cert" {
  provider = aws.east1
  domain_name = "www.${var.prod_domain}"
  subject_alternative_names = [var.prod_domain]
  validation_method = "DNS"
}

#landing page (and also app currently)
resource "aws_acm_certificate" "staging_cert" {
  provider = aws.east1
  domain_name = "www.${var.staging_domain}"
  subject_alternative_names = [var.staging_domain]
  validation_method = "DNS"
}

resource "aws_acm_certificate" "api_domain_cert" {
  provider = aws.east1
  domain_name = "*.artspot.io"
  subject_alternative_names = ["api.artspot.io", "www.artspot.io"]
  validation_method = "DNS"
}

resource "aws_ssm_parameter" "api_domain_cert" {
  name        = "/artspot/acm/api_domain_cert_arn"
  description = "prod api cert arn"
  type        = "String"
  value       = aws_acm_certificate.api_domain_cert.arn

  tags = {
    environment = "prod"
  }
}

resource "aws_acm_certificate" "api_subdomain_cert" {
  provider = aws.east1
  domain_name = "*.api.artspot.io"
  subject_alternative_names = [
    var.dev_api_domain, 
    var.staging_api_domain, 
    "www.${var.dev_api_domain}",
    "www.${var.staging_api_domain}"
  ]
  validation_method = "DNS"
}

resource "aws_ssm_parameter" "api_subdomain_cert" {
  name        = "/artspot/acm/api_subdomain_cert_arn"
  description = "api subdomain cert arn"
  type        = "String"
  value       = aws_acm_certificate.api_subdomain_cert.arn

  tags = {
    environment = "dev"
  }
}
