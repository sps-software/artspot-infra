output "user_pool_id" {
  value = module.cognito.user_pool_id
}

output "user_pool_arn" {
  value = module.cognito.user_pool_arn
}

output "user_pool_domain_id" {
  value = module.cognito.user_pool_domain_id
}

output "user_pool_domain_cloudfront_distribution_arn" {
  value = module.cognito.user_pool_domain_cloudfront_distribution_arn
}

output "user_pool_domain_s3_bucket" {
  value = module.cognito.user_pool_domain_s3_bucket
}

output "user_pool_web_client_id" {
  value = module.cognito.user_pool_web_client_id
}

output "user_pool_test_client_id" {
  value = module.cognito.user_pool_web_client_test_id
}