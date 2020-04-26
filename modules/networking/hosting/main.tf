
locals {
  dub_domain = "www.${var.domain}"
}

data "aws_canonical_user_id" "current_user" {}

data "aws_route53_zone" "main" {
  count = var.route53_zone_id == null ? 1 : 0
  name = var.domain
}

data "aws_acm_certificate" "main" {
  count = var.acm_cert_arn == null ? 1 : 0
  domain = local.dub_domain
}

data "template_file" "bucket_policy" {
  template = "${file("../../../iam/policy_templates/hosting-bucket-policy.tpl")}"
  vars = {
    originAccessIdentityArn = aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn
    bucketName = local.dub_domain
  }
}

resource "aws_s3_bucket" "site_logs" {
  bucket = "${var.domain}-site-logs"     
  policy = var.log_bucket_policy == null ? null : var.log_bucket_policy                                                                                                                                                                                                                                                                                                                         
  acl = "log-delivery-write"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "site_bucket" {
  bucket = local.dub_domain
  policy = var.site_bucket_policy == null ? data.template_file.bucket_policy.rendered : var.site_bucket_policy
  
  logging {
    target_bucket = aws_s3_bucket.site_logs.bucket
    target_prefix = "${local.dub_domain}/"
  }

  versioning {
    enabled = true
  }

  website {
    // These are the same for SPAs
    index_document = var.index_document
    error_document = var.error_document
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

resource "aws_cloudfront_distribution" "website_cdn" {
  enabled      = true
  price_class  = "PriceClass_All"
  http_version = "http2"
  aliases = [local.dub_domain, var.domain]

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.site_bucket.id}"
    domain_name = "${local.dub_domain}.s3.amazonaws.com"

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
    target_origin_id = "origin-bucket-${aws_s3_bucket.site_bucket.id}"

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
    acm_certificate_arn      = var.acm_cert_arn == null ? data.aws_acm_certificate.main[0].arn : var.acm_cert_arn
    ssl_support_method       = "sni-only"
  }
}

resource "aws_route53_record" "www_cdn_A_record" {
  zone_id = var.route53_zone_id == null ? data.aws_route53_zone.main[0].id : var.route53_zone_id
  name = local.dub_domain
  type = "A"
  alias {
    name = aws_cloudfront_distribution.website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_cdn_AAAA_record" {
  zone_id = var.route53_zone_id == null ? data.aws_route53_zone.main[0].id : var.route53_zone_id
  name = local.dub_domain
  type = "AAAA"
  alias {
    name = aws_cloudfront_distribution.website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
