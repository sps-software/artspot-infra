
module "ci_cd" {
  source="../../../modules/frontend/ci_cd"
  environment=var.environment
  project_name=var.project_name
  deploy_bucket=var.deploy_bucket
  sourceBranch=var.sourceBranch
}