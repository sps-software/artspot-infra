resource "aws_security_group" "rds_acces_dev_staging" {
  name        = "AllowDevStagingRDSAccess"
  description = "Allow access to dev/staging RDS"
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "AllowDevStagingRDSAccess"
  }
}

// resource "aws_security_group_rule" "ingress_443_private_subnets" {
//   security_group_id        = aws_security_group.vpc_endpoint_private_subnets_443.id
//   type                     = "ingress"
//   from_port                = 443
//   to_port                  = 443
//   protocol                 = "tcp"
//   cidr_blocks              = data.terraform_remote_state.vpc.outputs.private_subnet_cidr_blocks
// }