output "user_pool_id" {
  value = aws_cognito_user_pool.artists.id
}

output "user_pool_arn" {
  value = aws_cognito_user_pool.artists.arn
}

output "user_pool_domain_id" {
  value = aws_cognito_user_pool_domain.domain.id
}

output "user_pool_domain_cloudfront_distribution_arn" {
  value = aws_cognito_user_pool_domain.domain.cloudfront_distribution_arn 
}

output "user_pool_domain_s3_bucket" {
  value = aws_cognito_user_pool_domain.domain.s3_bucket
}

output "user_pool_web_client_id" {
  value = aws_cognito_user_pool_client.artspot-web.id
}

output "user_pool_web_client_test_id" {
  value = aws_cognito_user_pool_client.artspot-test-access.id
}