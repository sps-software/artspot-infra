
provider "aws" {
  region = "us-east-1"
}

locals {
  prod_domain = "www.${var.prod_site_name}"
  staging_domain = "www.${var.staging_site_name}"
}

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "sps-terraform-backend"
    key    = "acm/terraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_canonical_user_id" "current_user" {}


# Recommend not managing your Route53 with terraform considering 
# how many records you'll be adding from a variety of sources. 
# You don't want to accidentally overwrite those.
data "aws_route53_zone" "main" {
  name = var.prod_site_name
}

data "template_file" "prod_bucket_policy" {
  template = "${file("../../iam/policy_templates/hosting-bucket-policy.tpl")}"
  vars = {
    originAccessIdentityArn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
    bucketName = local.prod_domain
  }
}

data "template_file" "staging_bucket_policy" {
  template = "${file("../../iam/policy_templates/hosting-bucket-policy.tpl")}"
  vars = {
    originAccessIdentityArn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
    bucketName = local.staging_domain
  }
}

# resource "aws_s3_bucket_policy" "prod_bucket_policy" {
#   bucket = local.prod_domain
#   policy = template_file.prod_bucket_policy
# }

# resource "aws_s3_bucket_policy" "staging_bucket_policy" {
#   bucket = local.staging_domain
#   policy = template_file.prod_bucket_policy
# }

# resource "aws_s3_bucket_policy" "example" {
#   bucket = "${aws_s3_bucket.example.id}"
#   policy = "${data.aws_iam_policy_document.s3_policy.json}"
# }

resource "aws_s3_bucket" "prod_site_logs" {
  bucket = "${var.prod_site_name}-site-logs"                                                                                                                                                                                                                                                                                                                                
  acl = "log-delivery-write"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "staging_site_logs" {
  bucket = "${var.staging_site_name}-site-logs"                                                                                                                                                                                                                                                                                                                                
  acl = "log-delivery-write"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "prod_site_bucket" {
  bucket = local.prod_domain
  policy = data.template_file.prod_bucket_policy.rendered
  
  logging {
    target_bucket = aws_s3_bucket.prod_site_logs.bucket
    target_prefix = "${local.prod_domain}/"
  }

  versioning {
    enabled = true
  }

  website {
    // These are the same because React is a SPA
    index_document = "index.html"
    error_document = "index.html"
  }

  grant {
    id         = data.aws_canonical_user_id.current_user.id
    type       = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  grant {
    id         = aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id 
    type       = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }
}

resource "aws_s3_bucket" "staging_site_bucket" {
  bucket = local.staging_domain
  policy = data.template_file.staging_bucket_policy.rendered

  logging {
    target_bucket = aws_s3_bucket.staging_site_logs.bucket
    target_prefix = "${local.staging_domain}/"
  }

  versioning {
    enabled = true
  }

  website {
    // These are the same because React is a SPA
    index_document = "index.html"
    error_document = "index.html"
  }

  grant {
    id         = data.aws_canonical_user_id.current_user.id
    type       = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }

  grant {
    id         = aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id 
    type       = "CanonicalUser"
    permissions = ["FULL_CONTROL"]
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront origin access identity"
}


resource "aws_cloudfront_distribution" "prod_website_cdn" {
  enabled      = true
  price_class  = "PriceClass_All"
  http_version = "http2"
  aliases = ["${local.prod_domain}"]

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.prod_site_bucket.id}"
    domain_name = "${local.prod_domain}.s3.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
   geo_restriction {
      restriction_type = "none"
    }
  }

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD" ]
    cached_methods   = ["GET", "HEAD" ]
    target_origin_id = "origin-bucket-${aws_s3_bucket.prod_site_bucket.id}"

    min_ttl          = "0"
    default_ttl      = "300"                                              //3600
    max_ttl          = "1200"                                             //86400

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.prod_cert.arn
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_distribution" "staging_website_cdn" {
  enabled      = true
  price_class  = "PriceClass_All"
  http_version = "http2"
  aliases = ["${local.staging_domain}"]

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.staging_site_bucket.id}"
    domain_name = "${local.staging_domain}.s3.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD" ]
    cached_methods   = ["GET", "HEAD" ]
    target_origin_id = "origin-bucket-${aws_s3_bucket.staging_site_bucket.id}"

    min_ttl          = "0"
    default_ttl      = "300"                                              //3600
    max_ttl          = "1200"                                             //86400

    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.staging_cert.arn
    ssl_support_method       = "sni-only"
  }
}

resource "aws_route53_record" "www_prod_cdn_A_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = local.prod_domain
  type = "A"
  alias {
    name = aws_cloudfront_distribution.prod_website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.prod_website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_prod_cdn_AAAA_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = local.prod_domain
  type = "AAAA"
  alias {
    name = aws_cloudfront_distribution.prod_website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.prod_website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "www_staging_cdn_A_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = local.staging_domain
  type = "A"
  alias {
    name = aws_cloudfront_distribution.staging_website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.staging_website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_staging_cdn_AAAA_record" {
  zone_id = data.aws_route53_zone.main.zone_id
  name = local.staging_domain
  type = "AAAA"
  alias {
    name = aws_cloudfront_distribution.staging_website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.staging_website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}