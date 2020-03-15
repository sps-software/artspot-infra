
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "sps-terraform-backend"
    key            = "hosting/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "sps-terraform-locks"
    encrypt        = true
  }
}
resource "aws_acm_certificate" "cert" {
  domain_name = "*.artspot.io"
  validation_method = "DNS"
}

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
  bucket = "www.${var.prod_site_name}"
  logging {
    target_bucket = aws_s3_bucket.prod_site_logs.bucket
    target_prefix = "www.${var.prod_site_name}/"
  }

  versioning {
    enabled = true
  }

  website {
    // These are the same because React is a SPA
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket" "staging_site_bucket" {
  bucket = "www.${var.staging_site_name}"
  logging {
    target_bucket = aws_s3_bucket.staging_site_logs.bucket
    target_prefix = "www.${var.staging_site_name}/"
  }

  versioning {
    enabled = true
  }

  website {
    // These are the same because React is a SPA
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "cloudfront origin access identity"
}


resource "aws_cloudfront_distribution" "prod_website_cdn" {
  enabled      = true
  price_class  = "PriceClass_All"
  http_version = "http2"
  aliases = ["www.${var.prod_site_name}"]

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.prod_site_bucket.id}"
    domain_name = "www.${var.prod_site_name}.s3.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
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

   logging_config {
    include_cookies = false
    bucket          = "mylogs.s3.amazonaws.com"
    prefix          = "myprefix"
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
  }
}

resource "aws_cloudfront_distribution" "staging_website_cdn" {
  enabled      = true
  price_class  = "PriceClass_All"
  http_version = "http2"
  aliases = ["www.${var.staging_site_name}"]

  origin {
    origin_id   = "origin-bucket-${aws_s3_bucket.staging_site_bucket.id}"
    domain_name = "www.${var.staging_site_name}.s3.amazonaws.com"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
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
    acm_certificate_arn      = aws_acm_certificate.cert.arn
    ssl_support_method       = "sni-only"
  }
}
// Imported
resource "aws_route53_zone" "artspot" {
  name = "artspot.io"
}

resource "aws_route53_record" "www_prod_cdn_A_record" {
  zone_id = aws_route53_zone.artspot.zone_id
  name = "www.${var.prod_site_name}"
  type = "A"
  alias {
    name = aws_cloudfront_distribution.prod_website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.prod_website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_prod_cdn_AAAA_record" {
  zone_id = aws_route53_zone.artspot.zone_id
  name = "www.${var.prod_site_name}"
  type = "AAAA"
  alias {
    name = aws_cloudfront_distribution.prod_website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.prod_website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}


resource "aws_route53_record" "www_staging_cdn_A_record" {
  zone_id = aws_route53_zone.artspot.zone_id
  name = "www.${var.staging_site_name}"
  type = "A"
  alias {
    name = aws_cloudfront_distribution.staging_website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.staging_website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www_staging_cdn_AAAA_record" {
  zone_id = aws_route53_zone.artspot.zone_id
  name = "www.${var.staging_site_name}"
  type = "AAAA"
  alias {
    name = aws_cloudfront_distribution.staging_website_cdn.domain_name
    zone_id  = aws_cloudfront_distribution.staging_website_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}