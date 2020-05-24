data "terraform_remote_state" "vpc" {
  backend = "s3"
    config = {
    # Replace this with your bucket name!
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
    config = {
    # Replace this with your bucket name!
    bucket = "sps-terraform-backend"
    key    = "networking/security_groups/terraform.tfstate"
    region = "us-east-2"
  }
}


module "alb" {
  source = "../../../modules/networking/alb"
  name = "artspot-alb"
  tags = {}
  subnets = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  security_groups = [
    data.terraform_remote_state.security_groups.outputs.artspot_alb_tls_security_group
  ]
}
