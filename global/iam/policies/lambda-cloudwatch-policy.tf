resource "aws_iam_policy" "lambda-cloudwatch-access-policy" {
  description = "lambda cloudwatch access."
  name        = "LambdaCloudwatchAccess"
  path        = "/lambda/"
  policy      = jsonencode(
      {
          Statement = [
              {
                  Action   = [
                    "logs:*"
                  ]
                  Effect   = "Allow"
                  Resource = "arn:aws:logs:*:*:*"
              },
          ]
          Version   = "2012-10-17"
      }
  )
}