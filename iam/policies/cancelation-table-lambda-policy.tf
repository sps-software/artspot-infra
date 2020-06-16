data "terraform_remote_state" "cancelation-table-arn-staging" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "staging/backend/cancelation-survey-table/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_iam_policy" "cancelation-table-lambda-access-policy-staging" {
  description = "Provides to the cancelation survey Dynamodb table for the cancelation endpoint handler."
  name        = "CancelationDynamodbLambdaAccessPolicyStaging"
  path        = "/dynamodb/"
  policy      = jsonencode(
      {
          Statement = [
              {
                  Action   = [
                      "dynamodb:GetItem",
                      "dynamodb:PutItem",
                  ]
                  Effect   = "Allow"
                  Resource = data.terraform_remote_state.cancelation-table-arn-staging.outputs.arn
              },
          ]
          Version   = "2012-10-17"
      }
  )
}