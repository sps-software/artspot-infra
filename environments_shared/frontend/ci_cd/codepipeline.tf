
#TODO add data here for codepipeline and codebuild role arns 
# data "aws_iam" {

# }
data "aws_iam_role" "codepipeline_service_role" {
  name = "AWSCodePipelineServiceRole-us-east-2-${var.project_name}-web"
}

module "artspot-web-codepipeline" {
  source     = "../../modules/codepipeline"
  name       = "art-spot-web"
  aws_region = "us-east-2"
  role_arn         = data.aws_iam_role.codepipeline_service_role.arn
  environment      = "${var.environment}"
  sourceGithubUser = "sps-software"
  sourceRepo       = "art-spot-web"
  sourceBranch     = var.sourceBranch
  stages = [
    {
      name = aws_codebuild_project.this.name,
      actions = [
        {
          category = "Build",
          provider = "CodeBuild",
          configuration    = {
              "ProjectName" = aws_codebuild_project.this.name,
          },
          input_artifacts  = [
              "SourceArtifact"
          ],
          name             = "Build",
          output_artifacts = [
              "BuildArtifact"
          ]
        }]
    }
  ]

}
