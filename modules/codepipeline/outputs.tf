output "aws_region" {
  value       = var.aws_region
  description = "codepipeline aws region"
}

output "arn" {
  value       = aws_codepipeline.this.arn
  description = "codepipeline arn"
}

output "id" {
  value       = aws_codepipeline.this.id
  description = "Codepipeline id"
}

output "name" {
  value = aws_codepipeline.this.name
  description = "Codepipeline name"
}

output "s3_bucket_id" {
  value = aws_s3_bucket.this.id
  description = "artifact s3 bucket name"
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.this.arn
  description = "artifact s3 bucket name"
}
