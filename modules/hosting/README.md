# Terraform AWS Hosting module

## Overview

Inputs:

```
module "prod_site" {
  source = ...
  domain = "" // required (should not include "www."
  route53_zone_id = "" optional (if not provided, it looks for zone named after your input domain)
  site_bucket_policy = "" // optional. Default policy only allows Cloudfront Origin Identity access.
  log_bucket_policy = "" // optional. Default is none.
  index_document = "" // optional. Default is index.html
  error_document = "" // optional. Default is index.html for SPAs
  acm_cert_arn = "" // optional. If not provided it will look for one under "WWW.{your domain}"
}
```

This module will spin up an s3 hosting bucket and an accompanying log bucket as well as a cloud front distribution and A/AAAA Records for your input domain. The domain should not include "www.". Your ACM must be created prior to generating your Cloudfront distribution, so this is available as an input variable. By default, the module will include an ACM as a data source using "www.{your domain}". Your hosted zone id is also available as an input parameter, but will also be included as a data source by default if not provided. 

Example usage (assuming you bought your domain using Route53, so the hosted zone exists).:

```
acm.tf (already deployed):

provider "aws" {
  region = "us-east-1"
}

resource "aws_acm_certificate" "example_cert" {
  domain_name = "www.example.com"
  subject_alternative_names = [example.com]
  validation_method = "DNS"
}

hosting.tf: 

provider "aws" {
  region = "us-east-1"
}

module "example_site" {
  source = ...
  domain = "example.com"
}
```