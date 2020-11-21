data "aws_route53_zone" "artspot" {
  name         = "artspot.io"
}

data "aws_cognito_user_pools" "dev" {
  name = "artists-dev"
}

data "aws_cognito_user_pools" "staging" {
  name = "artists-staging"
}

data "aws_cognito_user_pools" "prod" {
  name = "artists-prod"
}


resource "aws_iam_policy" "deploy_accounts_api_role_policy" {
    name        = "deploy_accounts_api_role_policy"
  description = "Accounts API deplot policy"
  path        = "/service-role/"
  policy      = jsonencode(
    {
        Statement = [
            {
                Action   = [
                    "dynamodb:*",
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:dynamodb:us-east-2:455728032032:table/CancelationStatusTable-*",
                    "arn:aws:dynamodb:us-east-2:455728032032:table/CancelationSurveyTable-*"
                ]
            },
           {
                Action   = [
                    "ssm:GetParameter",
                    "ssm:GetParameters"
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
                    "arn:aws:ssm:us-east-2:455728032032:parameter/artspot/*/cognito/user_pool_admin_client_id"
                ]
            },
             {
                Action   = [
                    "kms:Decrypt",
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:kms:us-east-2:455728032032:key/ac4fe91a-ca01-400e-848f-54908467db96"
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
                    "arn:aws:cognito-idp:us-east-2:455728032032:userpool/${tolist(data.aws_cognito_user_pools.dev.ids)[0]}", 
                    "arn:aws:cognito-idp:us-east-2:455728032032:userpool/${tolist(data.aws_cognito_user_pools.staging.ids)[0]}", 
                    "arn:aws:cognito-idp:us-east-2:455728032032:userpool/${tolist(data.aws_cognito_user_pools.prod.ids)[0]}"
                ]
            },
            # serverless domain manager
           {
                Action   = [
                    "acm:ListCertificates",
                ]
                Effect   = "Allow"
                Resource = [
                    "*" 
                ]
            },
            {
                Action   = [
                    "apigateway:GET",
                    "apigateway:DELETE",
                    "apigateway:POST",
                    "apigateway:PATCH"
                ]
                Effect   = "Allow"
                Resource = [
                    "*",
                ]
            },
             {
                Action   = [
                    "execute-api:Invoke"
                ]
                Effect   = "Allow"
                Resource = [
                    "*",
                ]
            },
            {
                Action   = [
                    "cloudformation:GET",
                    "cloudformation:DescribeStacks",
                    "cloudformation:DescribeStackResource",
                    "cloudformation:ValidateTemplate",
                    "cloudformation:DescribeStackEvents"
                ]
                Effect   = "Allow"
                Resource = [
                    "*",
                ]
            },
             {
                Action   = [
                    "cloudformation:*"
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:cloudformation:us-east-2:455728032032:stack/artspot-accounts-api-*",
                    "arn:aws:cloudformation:us-east-2:455728032032:stack/artspot-accounts-api-*/*"
                ]
            },
            {
               Action   = [
                    "s3:*"
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:s3:::artspot-accounts-api-dev-serverlessdeploymentbuck-*",
                    "arn:aws:s3:::artspot-accounts-api-dev-serverlessdeploymentbuck-*/*",
                    "arn:aws:s3:::artspot-accounts-api-sta-serverlessdeploymentbuck-*",
                    "arn:aws:s3:::artspot-accounts-api-sta-serverlessdeploymentbuck-*/*",
                    "arn:aws:s3:::artspot-accounts-api-pro-serverlessdeploymentbuck-*",
                    "arn:aws:s3:::artspot-accounts-api-pro-serverlessdeploymentbuck-*/*"
                ]
            },
              {
                Action   = [
                    "cloudfront:UpdateDistribution"
                ]
                Effect   = "Allow"
                Resource = [
                    "*",
                ]
            },
            {
                Action   = [
                    "route53:ListHostedZones",
                    "route53:GetHostedZone",
                    "route53:ListResourceRecordSets"

                ]
                Effect   = "Allow"
                Resource = [
                    "*",
                ]
            },
             {
                Action   = [
                    "route53:ChangeResourceRecordSets"
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:route53:::hostedzone/${data.aws_route53_zone.artspot.zone_id}", #artspot.io
                ]
            },
            {
                Action   = [
                    "iam:CreateServiceLinkedRole"
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:iam::455728032032:role/aws-service-role/ops.apigateway.amazonaws.com/AWSServiceRoleForAPIGateway"
                ]
            },
             {
                Action   = [
                    "iam:*"
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:iam::455728032032:role/artspot/dev/serviceRoles/CancelationInitiateLambdaRole-dev",
                    "arn:aws:iam::455728032032:role/artspot/dev/serviceRoles/CancelationSurveyLambdaRole-dev",
                    "arn:aws:iam::455728032032:role/artspot/dev/serviceRoles/CancelationStatusLambdaRole-dev",
                    "arn:aws:iam::455728032032:role/artspot/staging/serviceRoles/CancelationInitiateLambdaRole-staging",
                    "arn:aws:iam::455728032032:role/artspot/staging/serviceRoles/CancelationSurveyLambdaRole-staging",
                    "arn:aws:iam::455728032032:role/artspot/staging/serviceRoles/CancelationStatusLambdaRole-staging",
                    "arn:aws:iam::455728032032:role/artspot/prod/serviceRoles/CancelationInitiateLambdaRole-prod",
                    "arn:aws:iam::455728032032:role/artspot/prod/serviceRoles/CancelationSurveyLambdaRole-prod",
                    "arn:aws:iam::455728032032:role/artspot/prod/serviceRoles/CancelationStatusLambdaRole-prod"
                ]
            },
             {
                Action   = [
                    "iam:GetRole"
                ]
                Effect   = "Allow"
                Resource = [
                    "*"
                ]
            },
             {
                Action   = [
                    "lambda:*",
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:lambda:us-east-2:455728032032:function:artspot-accounts-api-dev-*",
                    "arn:aws:lambda:us-east-2:455728032032:function:artspot-accounts-api-staging-*",
                    "arn:aws:lambda:us-east-2:455728032032:function:artspot-accounts-api-prod-*"
                ]
            },
           {
                Action   = [
                    "dynamodb:Create*",
                    "dynamodb:Describe*",
                    "dynamodb:List*",
                    "dynamodb:Update*",
                    "dynamodb:TagResource",
                    "dynamodb:UntagResource"
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:dynamodb:us-east-2:455728032032:table/CancelationStatusTable-*",
                    "arn:aws:dynamodb:us-east-2:455728032032:table/CancelationSurveyTable-*",
                ]
            },
             {
                Action   = [
                  "logs:Create*",
                  "logs:Update*",
                  "logs:Describe*",
                  "logs:List*",
                  "logs:Tag*"
                ]
                Effect   = "Allow"
                Resource = [
                    "*",
                ]
            },
            {
                Action   = [
                  "logs:DeleteLogGroup"
                ]
                Effect   = "Allow"
                Resource = [
                    "arn:aws:logs:us-east-2:455728032032:log-group:/aws/lambda/artspot-accounts-api-*",
                    "arn:aws:logs:us-east-2:455728032032:log-group:/aws/lambda/artspot-accounts-api-*:*",
                ]
            },
            {
                Action   = [
                  "apigateway:*"
                ]
                Effect   = "Allow"
                Resource = [
                    "*"
                ]
            },
            {
                Action   = [
                  "ec2:DescribeSecurityGroups",
                  "ec2:DescribeSubnets",
                  "ec2:DescribeVpcs",
                  "ec2:DescribeNetworkInterfaces"
                ]
                Effect   = "Allow"
                Resource = [
                    "*"
                ]
            },
        ]
        Version   = "2012-10-17"
    }
  )
}
