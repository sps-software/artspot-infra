data "terraform_remote_state" "hosting" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "hosting/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "us-east-2-alb" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/alb/terraform.tfstate"
    region = "us-east-2"
  }
}

