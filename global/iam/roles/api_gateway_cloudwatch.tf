resource "aws_iam_role" "cancelation-lambda-role" {
  name = "cancelationLambdaRole"
  assume_role_policy    = jsonencode(
    {
        Statement = [
            {
                Action    = "sts:AssumeRole"
                Effect    = "Allow"
                Principal = {
                    Service = "execute-api.amazonaws.com"
                }
                Sid       = ""
            },
        ]
        Version   = "2008-10-17"
    }
  )
  tags                  = {}
}