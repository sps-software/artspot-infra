resource "aws_iam_role" "codepipeline_service_role" {
  name = "codepipeline_service_role"
  assume_role_policy    = jsonencode(
      {
          Statement = [
              {
                  Action    = "sts:AssumeRole"
                  Effect    = "Allow"
                  Principal = {
                      Service = "codepipeline.amazonaws.com"
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

resource "aws_iam_role_policy_attachment" "codepipeline_service_role" {
  role       = aws_iam_role.codepipeline_service_role.name
  policy_arn = data.terraform_remote_state.policies.outputs.codepipeline_service_role_policy
}

resource "aws_ssm_parameter" "codepipeline_service_role" {
  type = "String"
  name = "/artspot/iam/codepipeline_service_role/arn"
  value = aws_iam_role.codepipeline_service_role.arn
}