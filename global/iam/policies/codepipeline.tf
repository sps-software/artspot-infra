resource "aws_iam_policy" "codepipeline_service_role_policy" {
  name        = "codepipeline_service_role_policy"
  description = "Policy used by codepipeline service role"
  path        = "/service-role/"
  policy = jsonencode(
    {
      Statement = [
        {
          "Action": [
              "iam:PassRole"
          ]
          "Resource": "*"
          "Effect": "Allow"
          "Condition": {
              "StringEqualsIfExists": {
                  "iam:PassedToService": [
                      "ec2.amazonaws.com",
                  ]
              }
          }
        },
        // {
        //     "Action": [
        //         "codedeploy:CreateDeployment",
        //         "codedeploy:GetApplication",
        //         "codedeploy:GetApplicationRevision",
        //         "codedeploy:GetDeployment",
        //         "codedeploy:GetDeploymentConfig",
        //         "codedeploy:RegisterApplicationRevision"
        //     ],
        //     "Resource": "*",
        //     "Effect": "Allow"
        // },
        {
            "Action": [
                "ec2:*",
                "elasticloadbalancing:*",
                "autoscaling:*",
                "cloudwatch:*",
                "s3:*",
                "sns:*",
                "cloudformation:*",
            ],
            "Resource": "*"
            "Effect": "Allow"
        },
        {
            "Action": [
                "codebuild:BatchGetBuilds",
                "codebuild:StartBuild"
            ],
            "Resource": "*"
            "Effect": "Allow"
        },
        {
            "Effect": "Allow"
            "Action": [
                "cloudformation:ValidateTemplate"
            ]
            "Resource": "*"
        },
        {
            "Effect": "Allow"
            "Action": [
                "ecr:DescribeImages"
            ]
            "Resource": "*"
        }
      ]
      Version   = "2012-10-17"
    }
  )
}