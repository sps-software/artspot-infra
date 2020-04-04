
data "aws_iam_role" "codepipeline_service_role" {
  name = "codebuild-artspot-web-build-service-role"
}