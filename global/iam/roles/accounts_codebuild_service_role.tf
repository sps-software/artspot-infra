
resource "aws_iam_role" "codebuild_accounts_service_role" {
  name = "codebuild_accounts_build"
  assume_role_policy    = jsonencode(
      {
          Statement = [
              {
                  Action    = "sts:AssumeRole"
                  Effect    = "Allow"
                  Principal = {
                      Service = "codebuild.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "codebuild_accounts_service_role" {
  role       = aws_iam_role.codebuild_accounts_service_role.name
  policy_arn = data.terraform_remote_state.policies.outputs.accounts_codebuild_role_policy
}

resource "aws_ssm_parameter" "codebuild_accounts_build" {
  type = "String"
  name = "/artspot/iam/codebuild_accounts_service_role/arn"
  value = aws_iam_role.codebuild_accounts_service_role.arn
}