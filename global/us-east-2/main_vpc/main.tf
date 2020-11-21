data "terraform_remote_state" "security_groups" {
  backend = "s3"
    config = {
    bucket = "sps-terraform-backend"
    key    = "networking/security_groups/terraform.tfstate"
    region = "us-east-2"
  }
}

module "main_vpc" {
  source = "../../../modules/vpc"
  aws_region = var.aws_region
  name = "main-vpc"
  num_public_subnets = 2
  num_private_subnets = 2
  subnet_cidr_block_ext = 20
}

resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.ecr.dkr"
  vpc_endpoint_type = "Interface"
   security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.ingress_443_private_subnets
  ]
}

resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.ingress_443_private_subnets
  ]
}
    
resource "aws_vpc_endpoint" "sns" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.sns"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.vpc_endpoint_sns
  ]
}

resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [module.main_vpc.private_route_table_id]
    policy = <<POLICY
    {
    "Statement": [
        {
        "Action": "*",
        "Effect": "Allow",
        "Resource": "*",
        "Principal": "*"
        }
    ]
    }
    POLICY
}

resource "aws_vpc_endpoint" "private_api_gateway" {
  vpc_id       = module.main_vpc.id
  service_name = "com.amazonaws.us-east-2.execute-api"
  vpc_endpoint_type = "Interface"
  security_group_ids = [
    data.terraform_remote_state.security_groups.outputs.vpc_endpoint_api_gateway
  ]
  // private_dns_enabled = true
  subnet_ids = module.main_vpc.private_subnet_ids
}

// resource "aws_vpc_endpoint" "private_api_gateway_2" {
//   vpc_id       = module.main_vpc.id
//   service_name = "com.amazonaws.us-east-2.execute-api"
//   vpc_endpoint_type = "Interface"
//   security_group_ids = [
//     data.terraform_remote_state.security_groups.outputs.vpc_endpoint_api_gateway
//   ]
//   private_dns_enabled = true
//   subnet_ids = [module.main_vpc.private_subnet_ids[1]]
// }


// resource "aws_vpc_endpoint" "api_gateway_private_1" {
//   vpc_id       = module.main_vpc.id
//   service_name = "com.amazonaws.us-east-2.execute-api"
//   vpc_endpoint_type = "Interface"
//   security_group_ids = [
//     data.terraform_remote_state.security_groups.outputs.vpc_endpoint_api_gateway
//   ]
//   private_dns_enabled = true
//   subnet_ids = [module.main_vpc.private_subnet_ids[1]]
// }

// resource "aws_vpc_endpoint" "api_gateway_public_0" {
//   vpc_id       = module.main_vpc.id
//   service_name = "com.amazonaws.us-east-2.execute-api"
//   vpc_endpoint_type = "Interface"
//   security_group_ids = [
//     data.terraform_remote_state.security_groups.outputs.vpc_endpoint_api_gateway
//   ]
//   private_dns_enabled = true
//   subnet_ids = [module.main_vpc.public_subnet_ids[0]]
// }


// resource "aws_vpc_endpoint" "api_gateway_public_1" {
//   vpc_id       = module.main_vpc.id
//   service_name = "com.amazonaws.us-east-2.execute-api"
//   vpc_endpoint_type = "Interface"
//   security_group_ids = [
//     data.terraform_remote_state.security_groups.outputs.vpc_endpoint_api_gateway
//   ]
//   private_dns_enabled = true
//   subnet_ids = [module.main_vpc.public_subnet_ids[1]]
// }

resource "aws_ssm_parameter" "private_subnet_a" {
  name        = "/artspot/vpc/private_subnet_a"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.private_subnet_ids[0]
}

resource "aws_ssm_parameter" "private_subnet_b" {
  name        = "/artspot/vpc/private_subnet_b"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.private_subnet_ids[1]
}

resource "aws_ssm_parameter" "demo_private_subnet_a" {
  name        = "/demo/vpc/private_subnet_a"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.private_subnet_ids[0]
}

resource "aws_ssm_parameter" "demo_private_subnet_b" {
  name        = "/demo/vpc/private_subnet_b"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.private_subnet_ids[1]
}

resource "aws_ssm_parameter" "public_subnet_a" {
  name        = "/artspot/vpc/public_subnet_a"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.public_subnet_ids[0]
}

resource "aws_ssm_parameter" "public_subnet_b" {
  name        = "/artspot/vpc/public_subnet_b"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.public_subnet_ids[1]
}

resource "aws_ssm_parameter" "vpc_id" {
  name        = "/artspot/vpc/id"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.id
}

resource "aws_ssm_parameter" "demo_vpc_id" {
  name        = "/demo/vpc/id"
  description = "The parameter description"
  type        = "String"
  value       = module.main_vpc.id
}

resource "aws_ssm_parameter" "vpc_private_api_gateway_endpoint" {
  name        = "/artspot/vpc/private_api_gateway_endpoint/id"
  description = "The parameter description"
  type        = "String"
  value       = aws_vpc_endpoint.private_api_gateway.id
}

resource "aws_ssm_parameter" "demo_vpc_private_api_gateway_endpoint" {
  name        = "/demo/vpc/private_api_gateway_endpoint/id"
  description = "The parameter description"
  type        = "String"
  value       = aws_vpc_endpoint.private_api_gateway.id
}

resource "aws_ssm_parameter" "dynamodb_endpoint" {
  name        = "/artspot/vpc/dynamodb_endpoint/id"
  description = "dynamodb vpc endpoint"
  type        = "String"
  value       = aws_vpc_endpoint.dynamodb_endpoint.id
}


// resource "aws_ssm_parameter" "vpc_private_api_gateway_endpoint_2" {
//   name        = "/artspot/vpc/private_api_gateway_endpoint_2/id"
//   description = "The parameter description"
//   type        = "String"
//   value       = aws_vpc_endpoint.private_api_gateway_2.id
// }

