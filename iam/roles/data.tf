
data "terraform_remote_state" "policies" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "iam/policies/terraform.tfstate"
    region = "us-east-2"
  }
}