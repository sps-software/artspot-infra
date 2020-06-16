output "ecs-task-execution-role-arn" {
  value = aws_iam_role.ecs-task-execution-role.arn
}

output "cancelation-lambda-role-arn" {
  value = aws_iam_role.cancelation-lambda-role.arn
}