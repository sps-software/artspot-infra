resource "aws_security_group" "vpc_endpoint_dynamodb" {
  name        = "dynamodbEndpointSG"
  description = "Allow connection to Dynamodb endpoint"
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "DynamodbEndpointSG"
  }
}

resource "aws_security_group_rule" "vpc_endpoint_dynamodb" {
  self = true
  from_port         = 0
  to_port           = 65535
  protocol                 = "tcp"
  description              = "Allow connection to dynamodb endpoint"
  security_group_id        = aws_security_group.vpc_endpoint_dynamodb.id
  type                     = "ingress"
}


resource "aws_ssm_parameter" "vpc_endpoint_dynamodb" {
  type = "String"
  name = "/artspot/dev/vpc/vpc_endpoint_dynamodb_sg"
  value = aws_security_group.vpc_endpoint_dynamodb.id
}