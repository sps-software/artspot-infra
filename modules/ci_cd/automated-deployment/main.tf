
// module "codepipeline" {
//   source = "../codepipeline"
//   name       = "art-spot-web"
//   aws_region = "us-east-2"
//   role_arn         = data.aws_iam_role.codepipeline_service_role.arn
//   environment      = "${var.environment}"
//   sourceGithubUser = "sps-software"
//   sourceRepo       = "art-spot-web"
//   sourceBranch     = var.sourceBranch
// } 


module "Test" {
  source = "cn-terraform/ecs-fargate-service/aws"
   version             = "1.0.4"
}