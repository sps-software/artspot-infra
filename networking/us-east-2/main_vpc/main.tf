
module "main_vpc" {
  source = "../../../modules/networking/vpc"
  aws_region = var.aws_region
  name = "main-vpc"
  num_public_subnets = 2
  num_private_subnets = 2
}
