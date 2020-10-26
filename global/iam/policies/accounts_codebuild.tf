resource "aws_iam_policy" "accounts_codebuild_role_policy" {
    name        = "accounts_codebuild_role_policy"
  description = "Accounts API Codebuild Policy Role"
  path        = "/service-role/"
  policy      = jsonencode(
    {
        Statement = [
            {
                Action   = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                ]
                Effect   = "Allow"
                Resource = [
                    "*"
                ]
            },
            {
                Action   = [
                    "codebuild:CreateReportGroup",
                    "codebuild:CreateReport",
                    "codebuild:UpdateReport",
                    "codebuild:BatchPutTestCases",
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:codebuild:us-east-2:455728032032:report-group/*",
                ]
            },
        ]
        Version   = "2012-10-17"
    }
  )
}
