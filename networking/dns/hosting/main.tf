// This is the module for hosting the static web page

locals {
  prod_domain = "www.${var.prod_site_name}"
  staging_domain = "www.${var.staging_site_name}"
}

data "aws_canonical_user_id" "current_user" {}

data "aws_route53_zone" "main" {
  name = var.prod_site_name
}

module "prod_hosting" {
  source = "../../../modules/networking/hosting"
  domain = "artspot.io"
  route53_zone_id = data.aws_route53_zone.main.id
}

module "staging_hosting" {
  source = "../../../modules/networking/hosting"
  domain = "staging.artspot.io"
  route53_zone_id = data.aws_route53_zone.main.id
}

resource "aws_ssm_parameter" "prod_distribution_id" {
  provider = aws.east2
  name        = "/artspot/networking/prod/distribution_id"
  description = "The parameter description"
  type        = "String"
  value       = module.prod_hosting.cloudfront_id
  tags = {
    environment = "prod"
  }
} 

resource "aws_ssm_parameter" "staging_distribution_id" {
  provider = aws.east2
  name        = "/artspot/networking/staging/distribution_id"
  description = "The parameter description"
  type        = "String"
  value       = module.staging_hosting.cloudfront_id

  tags = {
    environment = "staging"
  }
}