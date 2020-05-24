
data "terraform_remote_state" "vpc" {
  backend = "s3"
    config = {
    # Replace this with your bucket name!
    bucket = "sps-terraform-backend"
    key    = "networking/us-east-2/terraform.tfstate"
    region = "us-east-2"
  }
}

resource "aws_security_group" "allow_tls_lb" {
  name        = "allow_tls_lb"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  // ingress and egress are provided by fargate service module.

  tags = {
    Name = "allow_tls_lb"
  }
}