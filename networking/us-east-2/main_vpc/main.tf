data "terraform_remote_state" "security_groups" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/security_groups/terraform.tfstate"
    region = "us-east-2"
  }
}

module "main_vpc" {
  source = "../../../modules/networking/vpc"
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
