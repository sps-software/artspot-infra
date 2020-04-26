locals {
  environment_ext = "${var.environment == "" ? "" : "-"}${var.environment == "" ? "" : var.environment}"
}

resource "aws_s3_bucket" "this" {
  bucket = "${var.name}-bucket${local.environment_ext}"
  acl    = "private"
#  policy      = jsonencode(
#       {
#           Statement = [
#               {
#                   Action   = [
#                       "s3:PutObject",
#                       "s3:GetObject",
#                       "s3:GetObjectVersion",
#                       "s3:GetBucketAcl",
#                       "s3:GetBucketLocation",
#                   ]
#                   Effect   = "Allow"
#                   Resource = [
#                       "arn:aws:s3:::codepipeline-us-east-2-*",
#                   ]
#               },   
#           ]
#           Version   = "2012-10-17"
#       }
#   )
}

resource "aws_codepipeline" "this" {
  name     = "${var.name}${local.environment_ext}"
  role_arn = var.role_arn
  tags = merge(
    {"environment" =  var.environment, "Name" = "${var.name}${local.environment_ext}"},
    var.tags
  )
  artifact_store {
    location = var.artifactsEnabled ? aws_s3_bucket.this.id : null
    type     = var.artifactsEnabled ? "S3" : "None"
  }

  stage {
    name = "Source"

    action {
        category         = "Source"
        configuration    = {
            "Branch"               = var.sourceBranch
            "Owner"                = var.sourceGithubUser
            "PollForSourceChanges" = var.pollForSourceChanges
            "Repo"                 = var.sourceRepo
        }
        input_artifacts  = []
        name             = "Source"
        output_artifacts = [
            "SourceArtifact",
        ]
        owner            = var.sourceOwner
        provider         = var.sourceProvider
        run_order        = 1
        version          = "1"
    }
  }

  dynamic "stage" {
    for_each = var.stages
    content {
      name = stage.value.name
      dynamic "action" {
        for_each = stage.value.actions
        content {
          category         = action.value.category
          configuration    = action.value.configuration
          input_artifacts  = action.value.input_artifacts
          name             =   "${action.value.name}${local.environment_ext}"
          output_artifacts = action.value.output_artifacts
          owner            = "AWS"
          provider         = action.value.provider
          run_order        = 1
          version          = "1"
        }
      }
    }
  }
}
