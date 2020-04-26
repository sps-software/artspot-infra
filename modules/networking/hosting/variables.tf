variable "domain" {
  type = string
  description = "Domain to host (without www.)"
}

variable "route53_zone_id" {
  type = string
  default = null
  description = "Route 53 zone for your domain records. If this is not supplied, it will look for one under your input domain"
}

variable "site_bucket_policy" {
  type = string
  default = null
  description = "Override s3 bucket policy for your hosting bucket."
}

variable "log_bucket_policy" {
  type = string
  default = null
  description = "Override s3 bucket policy for your log bucket. Default is none."
}

variable "index_document" {
  type = string
  default = "index.html"
  description = "Cloudfront index document."
}

variable "error_document" {
  type = string
  default = "index.html"
  description = "Cloudfront error document. Defaults to index for SPAs but an be overriden for mmore traditional websites."
}

variable "acm_cert_arn" {
  type = string
  default = null
  description = "Your domains acm cert. If this is not supplied, it will look for one under www.{your domain}."
}