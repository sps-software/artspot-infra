resource "aws_security_group" "vpc_endpoint_private_subnets_443" {
  name        = "AllowTlsPrivateSubnets"
  description = "Open port 443 to private subnets"
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "AllowTlsPrivateSubnets"
  }
}

resource "aws_security_group_rule" "ingress_443_private_subnets" {
  security_group_id        = aws_security_group.vpc_endpoint_private_subnets_443.id
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = data.terraform_remote_state.vpc.outputs.private_subnet_cidr_blocks
}


resource "aws_ssm_parameter" "ingress_443_private_subnets" {
  name        = "/artspot/security_groups/ingress_443_private_subnets"
  description = "The parameter description"
  type        = "String"
  value       = aws_security_group.vpc_endpoint_private_subnets_443.id
}