resource "aws_iam_policy" "ecs-task-execution-role-policy" {
  description = "Provides access to other AWS service resources that are required to run Amazon ECS tasks"
  name        = "AmazonECSTaskExecutionRolePolicy"
  path        = "/service-role/"
  policy      = jsonencode(
      {
          Statement = [
              {
                  Action   = [
                      "ecr:GetAuthorizationToken",
                      "ecr:BatchCheckLayerAvailability",
                      "ecr:GetDownloadUrlForLayer",
                      "ecr:BatchGetImage",
                      "logs:CreateLogStream",
                      "logs:PutLogEvents",
                  ]
                  Effect   = "Allow"
                  Resource = "*"
              },
          ]
          Version   = "2012-10-17"
      }
  )
}