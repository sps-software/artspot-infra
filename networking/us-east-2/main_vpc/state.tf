
terraform {
  backend "s3" {
    bucket         = "sps-terraform-backend"
    key            = "networking/us-east-2/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "sps-terraform-locks"
    encrypt        = true
  }
}
