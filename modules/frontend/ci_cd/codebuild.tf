
data "aws_iam_role" "codebuild_service_role" {
  name = "codebuild-${var.project_name}-web-build-service-role"
}

resource "aws_codebuild_project" "this" {
  badge_enabled  = false
  build_timeout  = 60
  encryption_key = "arn:aws:kms:us-east-2:455728032032:alias/aws/s3"
  name           = "${var.project_name}-web-build-${var.environment}"
  queued_timeout = 480
  service_role   = data.aws_iam_role.codebuild_service_role.arn
  tags           = {}

  artifacts {
      encryption_disabled    = false
      name                   = "${var.project_name}-web-build"
      override_artifact_name = false
      packaging              = "NONE"
      type                   = "CODEPIPELINE"
  }

  cache {
      modes = []
      type  = "NO_CACHE"
  }

  environment {
      compute_type                = "BUILD_GENERAL1_SMALL"
      image                       = "aws/codebuild/standard:4.0"
      image_pull_credentials_type = "CODEBUILD"
      privileged_mode             = false
      type                        = "LINUX_CONTAINER"

      environment_variable {
          name  = "stage"
          type  = "PLAINTEXT"
          value = var.environment
      }

      environment_variable {
          name  = "ClientCognitoWebId"
          type  = "PARAMETER_STORE"
          value = "/${var.project_name}/${var.environment}/cognito/user_pool_web_client_id"
      }

      environment_variable {
          name  = "ClientCognitoPoolId"
          type  = "PARAMETER_STORE"
          value = "/${var.project_name}/${var.environment}/cognito/user_pool_id"
      }

       environment_variable {
          name  = "CognitoRegion"
          type  = "PLAINTEXT"
          value = "us-east-2"
      }

        environment_variable {
          name  = "Distribution"
          type  = "PARAMETER_STORE"
          value = "/${var.project_name}/networking/${var.environment}/distribution_id"
      }

       environment_variable {
          name  = "DeployBucket"
          type  = "PLAINTEXT"
          value = var.deploy_bucket
      }
  }

  logs_config {
      cloudwatch_logs {
          status = "ENABLED"
      }

      s3_logs {
          encryption_disabled = false
          status              = "DISABLED"
      }
  }

  source {
      git_clone_depth     = 0
      insecure_ssl        = false
      report_build_status = false
      type                = "CODEPIPELINE"
  }

}