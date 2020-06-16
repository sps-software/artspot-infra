data "terraform_remote_state" "vpc" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/security_groups/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "acm/terraform.tfstate"
    region = "us-east-2"
  }
}

data "aws_ssm_parameter" "cancelation_api_lambda_arn" {
  name = "/artspot/${var.environment}/api/cancelation-lambda"
}

module "alb" {
  source = "../../../modules/networking/alb"
  name = "artspot-alb-staging"
  environment = var.environment
  tags = {}
  subnets = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  security_groups = [
    data.terraform_remote_state.security_groups.outputs.artspot_alb_tls_security_group
  ]
}

module "cancel_membership_endpoint" {
  source = "../../lambda-endpoint-alb"
  lb_arn = module.alb.arn
  lambda_arn = data.aws_ssm_parameter.cancelation_api_lambda_arn.value
  environment = var.environment
  path_patterns = ["/cancelation", "/cancelation/survey", "/cancelation/health_check"]
  health_check_path = "/cancelation/health_check"
  cert_arn = var.cert_arn
}

resource "aws_ssm_parameter" "cancelation_listener_arn" {
  type = "String"
  name = "/artspot/${var.environment}/api/cancelation_listener_arn"
  value = module.cancel_membership_endpoint.web_listener_arn
}