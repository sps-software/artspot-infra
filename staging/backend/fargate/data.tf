data "terraform_remote_state" "vpc" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/ecs/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "alb" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/alb/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "security_groups" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/security_groups/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "acm/terraform.tfstate"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "iam_roles" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "iam/roles/terraform.tfstate"
    region = "us-east-2"
  }
}