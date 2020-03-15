variable "aws_region" {    
    default = "us-east-2"
    type = string
}

variable "environment" {
  default = ""
  type = string
}

variable "instance_tenancy" {
    default = "default"
    type = string
    description = "Tenancy of instances spun up within the VPC."
}

variable "name" {    
    type = string
    description = "vpc name"
}

variable "num_public_subnets" {
  description = "The number of public subnets"
  type        = number
  default = 1
}

variable "num_private_subnets" {
  description = "The number of public subnets"
  type        = number
  default = 1
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  type        = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr_block_ext" {
  description = "subnet cidr block extension, applied to all subnets"
  type        = string
  default = "24"
}

variable "subnet_cidr_blocks" {
  description = "To override the automatic subnet cidr indexing, provide a list of cide blocks"
  type          = list(number)
  default = []
}

variable "subnet_ipv6_cidr_blocks" {
    description = "To add specific ipv6 cidr blocks to the subnets on creation, provide a list equal to the amount of subnets"
    type = list(string)
    default = []
}

variable "assign_subnets_ipv6_address_on_creation" {
    description = "(Optional) Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address. Default is false"
    type = bool
    default = false
}

variable "internet_gateway_count" {
  description = "If you do not want an internet gateway, set this to zero"
  type        = number
  default = 1
}

variable "custom_route_table_count" {
  description = "If you do not want a custom route table, set this to zero"
  type        = number
  default = 1
}

variable "route_table_igw_cidr_block" {
  description = "cidr block for internet gateway route"
  type        = string
  default = "0.0.0.0/0"
}
