
resource "aws_iam_role" "ecs-task-execution-role" {
  name = "ecsTaskExecutionRole"
  assume_role_policy    = jsonencode(
    {
        Statement = [
            {
                Action    = "sts:AssumeRole"
                Effect    = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
                Sid       = ""
            },
        ]
        Version   = "2008-10-17"
    }
  )
  tags                  = {}
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-attach" {
  role       = aws_iam_role.ecs-task-execution-role.name
  policy_arn = data.terraform_remote_state.policies.outputs.ecs-task-execution-role-policy-arn
}