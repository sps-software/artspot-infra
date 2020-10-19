output "ecs-task-execution-role-policy-arn" {
  value = aws_iam_policy.ecs-task-execution-role-policy.arn
}

output "lambda-cloudwatch-access" {
  value = aws_iam_policy.lambda-cloudwatch-access-policy.arn
}

output "lambda-xray-access" {
  value = aws_iam_policy.lambda-xray-access-policy.arn
}

output "api-gateway-cloudwatch" {
  value = aws_iam_policy.api-gateway-cloudwatch-access-policy.arn
}

output "accounts_codebuild_role_policy" {
  value = aws_iam_policy.accounts_codebuild_role_policy.arn
}

output "codepipeline_service_role_policy" {
  value = aws_iam_policy.codepipeline_service_role_policy.arn
}