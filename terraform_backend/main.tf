terraform {
  backend "s3" {
    bucket         = "sps-terraform-backend"
    key            = "backend_state/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "sps-terraform-locks"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "sps-terraform-backend"
  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }
  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Creator     = "Terraform"
    Name        = "terraform-state-bucket"
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "sps-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Creator     = "Terraform"
    Name        = "terraform-state-lock-table"
  }
}