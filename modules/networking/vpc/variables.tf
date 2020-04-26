variable "aws_region" {
  default = "us-east-2"
  type    = string
}

variable "environment" {
  default = ""
  type    = string
}

variable "instance_tenancy" {
  default     = "default"
  type        = string
  description = "Tenancy of instances spun up within the VPC."
}

variable "name" {
  type        = string
  description = "vpc name"
}

variable "assign_generated_ipv6_cidr_block" {
  type        = bool
  default     = false
  description = "(Optional) Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block. Default is false."
}

variable "num_public_subnets" {
  description = "The number of public subnets"
  type        = number
  default     = 1
}

variable "num_private_subnets" {
  description = "The number of public subnets."
  type        = number
  default     = 1
}

variable "vpc_cidr_block" {
  description = "vpc cidr block."
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr_block_ext" {
  description = "subnet cidr block extension, applied to all subnets."
  type        = string
  default     = "24"
}

variable "subnet_cidr_blocks" {
  description = "To override the automatic subnet cidr indexing, provide a list of cide blocks."
  type        = list(number)
  default     = []
}

variable "subnet_ipv6_cidr_blocks" {
  description = "To add specific ipv6 cidr blocks to the subnets on creation, provide a list equal to the amount of subnets. The subnet size must use a /64 prefix length."
  type        = list(string)
  default     = []
}

variable "subnet_names" {
  description = "(Optional) Lost of subnet names to override the automatically generated ones."
  type        = list(string)
  default     = null
}

variable "assign_subnets_ipv6_address_on_creation" {
  description = "(Optional) Specify true to indicate that network interfaces created in each subnet should be assigned an IPv6 address. Default is false."
  type        = bool
  default     = false
}

variable "internet_gateway_enabled" {
  description = "If you do not want an internet gateway, set this to false."
  type        = bool
  default     = true
}

variable "custom_route_table_enabled" {
  description = "If you do not want a custom route table, set this to false."
  type        = bool
  default     = true
}

variable "route_table_igw_cidr_block" {
  description = "cidr block for internet gateway route."
  type        = string
  default     = "0.0.0.0/0"
}
