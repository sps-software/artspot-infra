resource "aws_security_group" "vpc_endpoint_api_gateway" {
  name        = "APIGatewayEndpointSG"
  description = "Allow connection to API Gateway endpoint from other SG."
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "APIGatewayEndpointSG"
  }
}

resource "aws_security_group" "connect_to_api_gateway_vpc_endpoint" {
  name        = "ConnectToAPIGatewayEndpointSG"
  description = "Resources in this sg can connect to the api gateway vpc endpoint."
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "ConnectToAPIGatewayEndpointSG"
  }
}

resource "aws_security_group_rule" "vpc_endpoint_api_gateway" {
  from_port                = 0
  protocol                 = "tcp"
  description               = "Allow connection to API Gateway endpoint"
  security_group_id        = aws_security_group.vpc_endpoint_api_gateway.id
  source_security_group_id = aws_security_group.connect_to_api_gateway_vpc_endpoint.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_ssm_parameter" "connect_to_api_gateway_vpc_endpoint" {
  type = "String"
  name = "yes"
  value = aws_security_group.connect_to_api_gateway_vpc_endpoint.id
}