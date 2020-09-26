resource "aws_security_group" "vpc_endpoint_sns" {
  name        = "SNSEndpointSG"
  description = "Allow connection to SNS endpoint from other SG."
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "SNSEndpointSG"
  }
}

resource "aws_security_group" "connect_to_sns_vpc_endpoint" {
  name        = "ConnectToSNSEndpointSG"
  description = "Resources in this sg can connect to the sns vpc endpoint."
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "ConnectToSNSEndpointSG"
  }
}

resource "aws_security_group_rule" "vpc_endpoint_sns" {
  from_port                = 0
  protocol                 = "tcp"
  description               = "Allow connection to SNS endpoint"
  security_group_id        = aws_security_group.vpc_endpoint_sns.id
  source_security_group_id = aws_security_group.connect_to_sns_vpc_endpoint.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_ssm_parameter" "connect_to_sns_vpc_endpoint" {
  type = "String"
  name = "/artspot/dev/vpc/vpc_endpoint_sns_sg"
  value = aws_security_group.connect_to_sns_vpc_endpoint.id
}