output "ecs-task-execution-role-arn" {
  value = aws_iam_role.ecs-task-execution-role.arn
}

output "codepipeline_service_role" {
  value = aws_iam_role.codepipeline_service_role.arn
}

output "codebuild_accounts_service_role" {
  value = aws_iam_role.codebuild_accounts_service_role.arn
}

output "deploy_accounts_api_role" {
  value = aws_iam_role.deploy_accounts_api.arn
}