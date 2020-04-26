
#TODO add data here for codepipeline and codebuild role arns 
# data "aws_iam" {

# }
data "aws_iam_role" "codepipeline_service_role" {
  name = "AWSCodePipelineServiceRole-us-east-2-artspot-web"
}

module "artspot-web-codepipeline" {
  source     = "../../../modules/ci_cd/codepipeline"
  name       = "art-spot-web"
  aws_region = "us-east-2"
  role_arn         = data.aws_iam_role.codepipeline_service_role.arn
  environment      = "prod"
  sourceGithubUser = "sps-software"
  sourceRepo       = "art-spot-web"
  stages = [
    {
      name = aws_codebuild_project.artspot-web-build-prod.name
      actions = [
        {
        category = "Build",
        provider = "CodeBuild",
        configuration    = {
            "ProjectName" = aws_codebuild_project.artspot-web-build-prod.name
        }
        input_artifacts  = [
            "SourceArtifact",
        ]
        name             = "Build"
        output_artifacts = [
            "BuildArtifact",
        ]
      }]
    }
  ]

}
# resource "aws_s3_bucket" "artspot-web-codepipeline" {
#   bucket = "artspot-web-codepipeline-prod"
#   acl    = "private"
# }

# resource "aws_codebuild_project" "artspot-web-build" {
#   badge_enabled  = false
#   build_timeout  = 60
#   encryption_key = "arn:aws:kms:us-east-2:455728032032:alias/aws/s3"
#   name           = "artspot-web-build"
#   queued_timeout = 480
#   service_role   = "arn:aws:iam::455728032032:role/service-role/codebuild-artspot-web-build-service-role"
#   tags           = {}

#   artifacts {
#       encryption_disabled    = false
#       name                   = "artspot-web-build"
#       override_artifact_name = false
#       packaging              = "NONE"
#       type                   = "CODEPIPELINE"
#   }

#   cache {
#       modes = []
#       type  = "NO_CACHE"
#   }

#   environment {
#       compute_type                = "BUILD_GENERAL1_SMALL"
#       image                       = "aws/codebuild/standard:4.0"
#       image_pull_credentials_type = "CODEBUILD"
#       privileged_mode             = false
#       type                        = "LINUX_CONTAINER"

#       environment_variable {
#           name  = "stage"
#           type  = "PLAINTEXT"
#           value = "prod"
#       }
#   }

#   logs_config {
#       cloudwatch_logs {
#           status = "ENABLED"
#       }

#       s3_logs {
#           encryption_disabled = false
#           status              = "DISABLED"
#       }
#   }

#   source {
#       git_clone_depth     = 0
#       insecure_ssl        = false
#       report_build_status = false
#       type                = "CODEPIPELINE"
#   }

# }

# resource "aws_codepipeline" "artspot-web-prod" {
#     name     = "artspot-web"
#     role_arn="arn:aws:iam::455728032032:role/service-role/AWSCodePipelineServiceRole-us-east-2-artspot-web"
#     artifact_store {
#         location = "codepipeline-us-east-2-467182702349"
#         type     = "S3"
#     }

#     stage {
#         name = "Source"

#         action {
#             category         = "Source"
#             configuration    = {
#                 "Branch"               = "master"
#                 "Owner"                = "sps-software"
#                 "PollForSourceChanges" = "false"
#                 "Repo"                 = "art-spot-web"
#             }
#             input_artifacts  = []
#             name             = "Source"
#             output_artifacts = [
#                 "SourceArtifact",
#             ]
#             owner            = "ThirdParty"
#             provider         = "GitHub"
#             run_order        = 1
#             version          = "1"
#         }
#     }
#     stage {
#         name = "Build"

#         action {
#             category         = "Build"
#             configuration    = {
#                 "ProjectName" = "artspot-web-build"
#             }
#             input_artifacts  = [
#                 "SourceArtifact",
#             ]
#             name             = "Build"
#             output_artifacts = [
#                 "BuildArtifact",
#             ]
#             owner            = "AWS"
#             provider         = "CodeBuild"
#             run_order        = 1
#             version          = "1"
#         }
#     }
# }