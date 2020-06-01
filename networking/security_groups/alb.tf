resource "aws_security_group" "allow_tls_lb" {
  name        = "allow_tls_lb"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "allow_tls_lb"
  }
}