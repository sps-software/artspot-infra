output "id" {
  value       = aws_vpc.this.id
  description = "vpc id"
}

output "arn" {
  value       = aws_vpc.this.arn
  description = "vpc arn"
}

output "main_route_table_id" {
  value       = aws_vpc.this.main_route_table_id
  description = "vpc main route table id"
}

output "ipv6_association_id" {
  value       = aws_vpc.this.ipv6_association_id
  description = "The association ID for the IPv6 CIDR block"
}

output "cidr_block" {
  value       = aws_vpc.this.cidr_block
  description = "The IPv4 CIDR block of the VPC"
}

output "ipv6_cidr_block" {
  value       = aws_vpc.this.ipv6_cidr_block
  description = "The IPv6 CIDR block"
}

output "subnet_ids" {
  value = aws_subnet.this[*].id
}

output "default_network_acl_id" {
  value       = aws_vpc.this.default_network_acl_id
  description = "The ID of the network ACL created by default on VPC creation"
}

output "default_security_group_id" {
  value       = aws_vpc.this.default_security_group_id
  description = "The ID of the security group created by default on VPC creation"
}

output "default_route_table_id" {
  value       = aws_vpc.this.default_route_table_id
  description = "The ID of the route table created by default on VPC creation"

}
output "private_subnet_ids" {
  value       = [for val in aws_subnet.this[*] : val if val.map_public_ip_on_launch == false][*].id
  description = "ids of all private subnets"
}

output "public_subnet_ids" {
  value       = [for val in aws_subnet.this[*] : val if val.map_public_ip_on_launch == true][*].id
  description = "ids of all public subnets"
}

output "subnet_name_id_map" {
  value       = zipmap(aws_subnet.this[*].tags.Name, aws_subnet.this[*].id)
  description = "a mapping of subnet name tags to their corresponding ids"
}

output "subnet_id_arn_map" {
  value       = zipmap(aws_subnet.this[*].id, aws_subnet.this[*].arn)
  description = "a mapping of subnet ids to their corresponding arns"
}

output "subnet_name_arn_map" {
  value       = zipmap(aws_subnet.this[*].tags.Name, aws_subnet.this[*].arn)
  description = "a mapping of subnet ids to their corresponding arns"
}

