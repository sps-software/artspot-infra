// This module is not in use in favor of api gateway

data "terraform_remote_state" "acm" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "acm/terraform.tfstate"
    region = "us-east-2"
  }
}

module "api" {
  source = "../../../modules/backend/api"
  cert_arn = data.terraform_remote_state.acm.outputs.staging_api_cert_arn
  environment = "staging"
}
