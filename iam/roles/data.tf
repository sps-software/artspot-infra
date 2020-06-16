

data "aws_iam_policy_document" "managed_lambda_execution_policy" {
  statement {
    actions = [
      "logs:*"
    ]

    resources = ["arn:aws:logs:*:*:*"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "terraform_remote_state" "policies" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "iam/policies/terraform.tfstate"
    region = "us-east-2"
  }
}