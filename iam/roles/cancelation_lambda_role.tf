
resource "aws_iam_role" "cancelation-lambda-role" {
  name = "cancelationLambdaRole"
  assume_role_policy    = jsonencode(
    {
        Statement = [
            {
                Action    = "sts:AssumeRole"
                Effect    = "Allow"
                Principal = {
                    Service = "lambda.amazonaws.com"
                }
                Sid       = ""
            },
        ]
        Version   = "2008-10-17"
    }
  )
  tags                  = {}
}

resource "aws_iam_role_policy_attachment" "cancelation-lambda-role-attach" {
  role       = aws_iam_role.cancelation-lambda-role.name
  policy_arn = data.terraform_remote_state.policies.outputs.cancelation-table-lambda-access-policy-staging
}

resource "aws_iam_role_policy_attachment" "cancelation-lambda-role-attach-cloudwatch" {
  role       = aws_iam_role.cancelation-lambda-role.name
  policy_arn = data.terraform_remote_state.policies.outputs.lambda-cloudwatch-access
}

resource "aws_iam_role_policy_attachment" "cancelation-lambda-role-attach-xray" {
  role       = aws_iam_role.cancelation-lambda-role.name
  policy_arn = data.terraform_remote_state.policies.outputs.lambda-xray-access
}


resource "aws_ssm_parameter" "cancelation_labda_role" {
  type = "String"
  name = "/artspot/iam/cancelation-lambda-role-staging"
  value = aws_iam_role.cancelation-lambda-role.arn
}