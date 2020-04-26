output "cloudfront_arn" {
  value = aws_cloudfront_distribution.website_cdn.arn
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.website_cdn.id
}

output "cloudfront_domain" {
  value = aws_cloudfront_distribution.website_cdn.domain_name
  description = "cloudfront domain - helpful for debugging."
}

output "site_bucket_id" {
  value = aws_s3_bucket.site_bucket.id
}

output "site_bucket_arn" {
  value = aws_s3_bucket.site_bucket.arn
}

output "log_bucket_id" {
  value = aws_s3_bucket.site_logs.id
}

output "log_bucket_arn" {
  value = aws_s3_bucket.site_logs.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.site_bucket.bucket_domain_name 
  description = "S3 bucket domain - helpful for debugging. Won't work unless you set the bucket and its objects to public."
}