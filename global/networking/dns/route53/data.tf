data "terraform_remote_state" "hosting" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "hosting/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "us-east-2-alb-staging" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "staging/us-east-2/api/terraform.tfstate"
    region = "us-east-2"
  }
}


//need to update staging alb to staging state bucket and also update data source to include that