output "id" {
  value       = module.main_vpc.id
  description = "vpc id"
}

output "arn" {
  value       = module.main_vpc.arn
  description = "vpc arn"
}

output "main_route_table_id" {
  value        = module.main_vpc.main_route_table_id
  description = "vpc main route table id"
}

output "public_route_table_id" {
  value       = module.main_vpc.public_route_table_id
  description = "custom public route table id"
}

output "private_route_table_id" {
  value       = module.main_vpc.private_route_table_id
  description = "private route table id"
}

output "cidr_block" {
  value = module.main_vpc.cidr_block
  description = "The IPv4 CIDR block of the VPC"
}

output "ipv6_cidr_block" {
   value        = module.main_vpc.ipv6_cidr_block 
   description  = "The IPv6 CIDR block"
}

output "subnet_ids" {
  value = module.main_vpc.subnet_ids
}

output "default_network_acl_id" {
  value = module.main_vpc.default_network_acl_id
  description = "The ID of the network ACL created by default on VPC creation"
}

output "default_security_group_id" {
  value = module.main_vpc.default_security_group_id
  description = "The ID of the security group created by default on VPC creation"
}

output "default_route_table_id" {
  value = module.main_vpc.default_route_table_id
  description = "The ID of the route table created by default on VPC creation"
}

output "private_subnet_ids" {
  value = module.main_vpc.private_subnet_ids
  description = "ids of all private subnets"
}

output "public_subnet_ids" {
  value = module.main_vpc.public_subnet_ids
  description = "ids of all public subnets"
}

output "subnet_name_id_map" {
  value = module.main_vpc.subnet_name_id_map
  description = "a mapping of subnet name tags to their corresponding ids"
}

output "subnet_id_arn_map" {
  value = module.main_vpc.subnet_id_arn_map
  description = "a mapping of subnet ids to their corresponding arns"
}

output "subnet_name_arn_map" {
  value = module.main_vpc.subnet_name_arn_map
  description = "a mapping of subnet ids to their corresponding arns"
}

output "public_subnet_cidr_blocks" {
  value = module.main_vpc.public_subnet_cidr_blocks
}

output "private_subnet_cidr_blocks" {
  value = module.main_vpc.private_subnet_cidr_blocks
}

output "public_cidr_blocks_by_id" {
  value = module.main_vpc.public_cidr_blocks_by_id
}

output "private_cidr_blocks_by_id" {
  value =  module.main_vpc.private_cidr_blocks_by_id
}

output "private_api_gateway_vpce_id" {
  value = aws_vpc_endpoint.private_api_gateway.id
}
