
resource "aws_iam_role" "deploy_accounts_api" {
  name = "deploy_accounts_api"
  assume_role_policy    = jsonencode(
      {
          Statement = [
              {
                  Action    = "sts:AssumeRole"
                  Effect    = "Allow"
                  Principal = {
                      AWS = [
                        aws_iam_role.codebuild_accounts_service_role.arn,
                        "arn:aws:iam::455728032032:user/personal-macbook-cli"
                      ]
                  }
              },
          ]
          Version   = "2012-10-17"
      }
  )
  force_detach_policies = false
  max_session_duration  = 3600
  path                  = "/service-role/"
  tags                  = {}
}

resource "aws_iam_role_policy_attachment" "deploy_accounts_api" {
  role       = aws_iam_role.deploy_accounts_api.name
  policy_arn = data.terraform_remote_state.policies.outputs.deploy_accounts_api_role_policy
}

resource "aws_ssm_parameter" "deploy_accounts_api" {
  type = "String"
  name = "/artspot/iam/deploy_accounts_api/arn"
  value = aws_iam_role.deploy_accounts_api.arn
}