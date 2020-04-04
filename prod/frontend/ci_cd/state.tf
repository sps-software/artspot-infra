terraform {
  backend "s3" {
    bucket         = "sps-terraform-backend"
    key            = "prod/frontend/ci_cd/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "sps-terraform-locks"
    encrypt        = true
  }
}
