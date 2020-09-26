resource "aws_iam_policy" "api-gateway-cloudwatch-access-policy" {
  description = "api-gateway cloudwatch access."
  name        = "APIGatewayCloudwatchAccess"
  path        = "/api-gateway/"
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