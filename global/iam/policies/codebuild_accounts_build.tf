resource "aws_iam_policy" "accounts_codebuild_role_policy" {
    name        = "accounts_codebuild_role_policy"
  description = "Accounts API Condebuild Policy Role"
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
                    "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-accounts-build-prod",
                    "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-accounts-build-prod:*",
                    "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-accounts-build-staging",
                    "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-accounts-build-staging:*",
                    "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-accounts-build-dev",
                    "arn:aws:logs:us-east-2:455728032032:log-group:/aws/codebuild/artspot-accounts-build-dev:*"
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
                    "arn:aws:s3:::art-spot-accounts-pipeline-bucket-prod",
                    "arn:aws:s3:::art-spot-accounts-pipeline-bucket-prod/*",
                    "arn:aws:s3:::art-spot-accounts-pipeline-bucket-staging",
                    "arn:aws:s3:::art-spot-accounts-pipeline-bucket-staging/*",
                    "arn:aws:s3:::art-spot-accounts-pipeline-bucket-dev",
                    "arn:aws:s3:::art-spot-accounts-pipeline-bucket-dev/*"
                ]
            },
            {
                Action   = [
                    "dynamodb:Query",
                    "dynamodb:GetItem",
                    "dynamodb:PutItem",
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:dynamodb:us-east-2:455728032032:table/CancelationStatusTable-*",
                    "arn:aws:dynamodb:us-east-2:455728032032:table/CancelationSurveyTable-*"
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
                    "arn:aws:codebuild:us-east-2:455728032032:report-group/artspot-accounts-build-*",
                ]
            },
            {
                Action   = [
                    "ssm:GetParameters",
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/security_groups/ingress_443_private_subnets",
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/vpc/connect_to_api_gateway_vpc_endpoint",
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/vpc/private_subnet_a",
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/vpc/private_subnet_b",
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/acm/api_subdomain_cert_arn",
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/acm/api_domain_cert_arn",
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/*/cognito/user_pool_id",
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/*/cognito/user_pool_admin_client_id} "
                ]
            },
              {
                Action   = [
                    "cognito-idp:AdminCreateUser",
                    "cognito-idp:AdminDeleteUser",
                    "cognito-idp:AdminInitiateAuth",
                    "cognito-idp:AdminRespondToAuthChallenge",
                    "cognito-idp:AdminGetUser",

                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:cognito-idp:us-east-2:455728032032:userpool/us-east-2_9y6GE449b", #dev
                    "arn:aws:cognito-idp:us-east-2:455728032032:userpool/us-east-2_wkPGgHFJp", #staging 
                    "arn:aws:cognito-idp:us-east-2:455728032032:userpool/us-east-2_MSR05HR63"  #prod
                ]
            },
        ]
        Version   = "2012-10-17"
    }
  )
}
