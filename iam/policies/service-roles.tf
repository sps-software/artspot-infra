resource "aws_iam_policy" "CodeBuildBasePolicy-artspot-web-build-us-east-2" {
  name        = "CodeBuildBasePolicy-artspot-web-build-us-east-2"
  description = "Policy used in trust relationship with CodeBuild"
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
                      "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-web-build-prod",
                      "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-web-build-prod:*",
                      "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-web-build-staging",
                      "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-web-build-staging:*",
                      "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/*",

                  ]
              },
              {
                  Action   = [
                      "s3:PutObject",
                      "s3:GetObject",
                      "s3:GetObjectVersion",
                      "s3:GetBucketAcl",
                      "s3:GetBucketLocation",
                  ]
                  Effect   = "Allow"
                  Resource = [
                      "arn:aws:s3:::art-spot-web-bucket-prod",
                      "arn:aws:s3:::art-spot-web-bucket-prod/*",
                      "arn:aws:s3:::art-spot-web-bucket-staging",
                      "arn:aws:s3:::art-spot-web-bucket-staging/*"
                  ]
              },
              {
                  Action   = [
                      "s3:PutObject",
                      "s3:PutObjectAcl",
                      "s3:GetObject",
                      "s3:GetObjectVersion",
                      "s3:GetBucketVersioning",
                  ]
                  Effect   = "Allow"
                  Resource = [
                      "arn:aws:s3:::www.artspot.io",
                      "arn:aws:s3:::www.artspot.io/*",
                      "arn:aws:s3:::www.staging.artspot.io",
                      "arn:aws:s3:::www.staging.artspot.io/*",
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
                      "arn:aws:codebuild:us-east-2:455728032032:report-group/artspot-web-build-*",
                  ]
              },
               {
                  Action   = [
                      "ssm:GetParameters",
                  ]
                  Effect   = "Allow"
                  Resource = [
                      "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/networking/prod/distribution_id",
                      "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/networking/staging/distribution_id",
                      "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/prod/cognito/user_pool_id",
                      "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/prod/cognito/user_pool_web_client_id",
                      "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/staging/cognito/user_pool_id",
                      "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/staging/cognito/user_pool_web_client_id"
                  ]
              },
               {
                  Action   = [
                      "cloudfront:CreateInvalidation",
                  ]
                  Effect   = "Allow"
                  Resource = [
                      "arn:aws:cloudfront::455728032032:distribution/*",
                  ]
              },
          ]
          Version   = "2012-10-17"
      }
  )
}

# resource "aws_iam_role" "codebuild-artspot-web-build-service-role" {
#   name = "codebuild-artspot-web-build-service-role"
# }