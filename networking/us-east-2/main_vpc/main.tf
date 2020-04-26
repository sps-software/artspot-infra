
module "main_vpc" {
  source = "../../../modules/networking/vpc"
  aws_region = var.aws_region
  name = "main-vpc"
}
