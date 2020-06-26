output "ecs-task-execution-role-policy-arn" {
  value = aws_iam_policy.ecs-task-execution-role-policy.arn
}

output "cancelation-table-lambda-access-policy-staging" {
  value = aws_iam_policy.cancelation-table-lambda-access-policy-staging.arn
}

output "lambda-cloudwatch-access" {
  value = aws_iam_policy.lambda-cloudwatch-access-policy.arn
}

output "lambda-xray-access" {
  value = aws_iam_policy.lambda-xray-access-policy.arn
}