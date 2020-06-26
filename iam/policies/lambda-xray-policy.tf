resource "aws_iam_policy" "lambda-xray-access-policy" {
  description = "lambda xray access."
  name        = "LambdaXRayAccess"
  path        = "/lambda/"
  policy      = jsonencode(
      {
          Statement = [
              {
                  Action   = [
                    "xray:PutTraceSegment",
                    "xray:PutTraceSegments",
                    "xray:PutTelemetryRecords"
                  ]
                  Effect   = "Allow"
                  Resource = "*"
              },
          ]
          Version   = "2012-10-17"
      }
  )
}