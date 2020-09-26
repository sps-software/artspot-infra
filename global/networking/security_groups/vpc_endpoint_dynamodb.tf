resource "aws_security_group" "vpc_endpoint_dynamodb" {
  name        = "dynamodbEndpointSG"
  description = "Allow connection to Dynamodb endpoint from other SG."
  vpc_id      = data.terraform_remote_state.vpc.outputs.id

  tags = {
    Name = "DynamodbEndpointSG"
  }
}

resource "aws_ssm_parameter" "vpc_endpoint_dynamodb" {
  type = "String"
  name = "/artspot/dev/vpc/vpc_endpoint_dynamodb_sg"
  value = aws_security_group.vpc_endpoint_dynamodb.id
}