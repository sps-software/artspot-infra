data "terraform_remote_state" "security_groups" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/security_groups/terraform.tfstate"
    region = "us-east-2"
  }
}

module "main_vpc" {
  source = "../../../modules/vpc"
  aws_region = var.aws_region
  name = "main-vpc"
  num_public_subnets = 2
  num_private_subnets = 2
}

resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
   security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.ingress_443_private_subnets
  ]
}

resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.ingress_443_private_subnets
  ]
}
    
resource "aws_vpc_endpoint" "sns" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.sns"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.vpc_endpoint_sns
  ]
}

resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.dynamodb"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint" "api_gateway" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.execute-api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.vpc_endpoint_api_gateway
  ]
  private_dns_enabled = true
  subnet_ids = module.main_vpc.private_subnet_ids
}


resource "aws_ssm_parameter" "private_subnet_a" {
  name        = "/artspot/vpc/private_subnet_a"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.private_subnet_ids[0]
}

resource "aws_ssm_parameter" "private_subnet_b" {
  name        = "/artspot/vpc/private_subnet_b"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.private_subnet_ids[1]
}

resource "aws_ssm_parameter" "public_subnet_a" {
  name        = "/artspot/vpc/public_subnet_a"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.public_subnet_ids[0]
}

resource "aws_ssm_parameter" "public_subnet_b" {
  name        = "/artspot/vpc/public_subnet_b"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.public_subnet_ids[1]
}

resource "aws_ssm_parameter" "vpc_id" {
  name        = "/artspot/vpc/id"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.id
}
