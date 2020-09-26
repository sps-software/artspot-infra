data "terraform_remote_state" "vpc" {
  backend = "s3"
    config = {
    # Replace this with your bucket name!
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/terraform.tfstate"
    region = "us-east-2"
  }
}