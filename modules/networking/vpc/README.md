# VPC Module

## Overview
Inputs:

```
module "main_vpc" {
  source = ...
  aws_region = "" // optional (default: "us-east-2") 
  name = ""// required
  vpc_cidr_block = "" // optional (default: "10.0.0.0/16"
  num_public_subnets = 2 // optional (default: 1)
  num_private_subnets = 2 // optional (default: 1)
  instance_tenancy = "" // optional (default:  "default")
  environment = "" // optional (default: "")
  subnet_cidr_block_ext = "" // optional (default: "24")
  subnet_cidr_blocks = [""] // optional: (default: [])
  subnet_ipv6_cidr_blocks = [""] // optional: (default: [])
	assign_subnets_ipv6_address_on_creation = // optional (default: false)
	internet_gateway_count = 1 // optional (default: 1)
	custom_route_table_count = 1 // optional (default: 1)
	route_table_igw_cidr_block = "" // optional (default: "0.0.0.0/0" 
}
```
This module will build a VPC with a specified number of public and private subnets, as well as an internet gateway and a custom route table if desired. Subnet ids, arns, and other variables are available as output lists as well a mappings. e.g.

```
module.this.private_subnet_ids = [
  "subnet-xxxxxxxxxxxxxxxxx",
]

module.this.public_subnet_ids = [
  "subnet-xxxxxxxxxxxxxxxxx",
]

module.this.subnet_name_id_map = 
{
	"public-subnet-us-east-2b": "subnet-xxxxxxxxxxxxxxxxx"
}

module.this.subnet_name_arn_map = 
{
	"public-subnet-us-east-2b": "arn:aws:ec2:us-east-2:xxxxxxxxxxxx:subnet/subnet-01d696bb78b00f992"
}

module.this.subnet_id_arn_map = {
  "subnet-xxxxxxxxxxxxxxxxx" = "arn:aws:ec2:us-east-2:xxxxxxxxxxxx:subnet/subnet-01d696bb78b00f992"
}
```

Subnet cidr blocks are created by incrementing the third section of the vpc cidr block. For example:

```
module "main_vpc" {
  source = "path/to/modules/vpc"
  aws_region = var.aws_region
  name = "main-vpc"
  vpc_cidr_block = "178.222.123.091/16"
  num_public_subnets = 2
  num_private_subnets = 2
}
```

Would output the following subnet cider blocks (the extension defaults to 24):

```
["178.222.123.091/24", "178.222.124.091/24",
"178.222.125.091/24", "178.222.126.091/24"]
```

This would obviously break if your third section of your cider block plus the number of subnets is greater than 254. If you use a custom extension with the `subnet_cidr_block_ext` variable, it should also be within the range of your vpc's cidr extension as well.

Alternatively, you can override subnet cidr blocks with a custom list using the `subnet_cidr_blocks` variable, however the length must be equal to the amount of public and private subnets configured. 

The route table has a default route for your nat gateway set to cidr block: "0.0.0.0/0" for outside access. If you would not like to add a nat gateway or a custom route table, set both counts to zero (both must be set or not set). 

You can provide an optional environment variable, which will be appended to all name tags with a hyphen.

 For exmaple:  environment_variable: "prod" would result in:
 ```
 resource "aws_vpc" "this" {
   ...
   tags = {
     Name = "main-vpc-prod"
   }
 }
 ```

