resource "aws_acm_certificate" "prod_cert" {
  domain_name = "www.${var.prod_domain}"
  subject_alternative_names = [var.prod_domain]
  validation_method = "DNS"
}

resource "aws_acm_certificate" "staging_cert" {
  domain_name = "www.${var.staging_domain}"
  subject_alternative_names = [var.staging_domain]
  validation_method = "DNS"
}

# resource "aws_acm_certificate" "auth_cert" {
#   domain_name = "www.${var.auth_domain}"
#   subject_alternative_names = [var.auth_domain]
#   validation_method = "DNS"
# }