

locals {
    total_subnets = var.num_private_subnets + var.num_public_subnets
    az_num_map = {"0" = "a", "1" = "b", "2" = "b"}
    environment_ext = "${var.environment == "" ? "" : "-"}${var.environment == "" ? "" : var.environment}"
    cidr_part_1_2 = regex("(\\d{1,3}.\\d{1,3}).\\d{1,3}.\\d{1,3}", var.vpc_cidr_block)[0]
    cidr_part3 = regex("\\d{1,3}.\\d{1,3}.(\\d{1,3}).\\d{1,3}", var.vpc_cidr_block)[0]
    cidr_part4 = regex("\\d{1,3}.\\d{1,3}.\\d{1,3}.(\\d{1,3})", var.vpc_cidr_block)[0]
}

locals {
    auto_subnet_cidr_blocks = [for i in range(local.total_subnets): "${local.cidr_part_1_2}.${tonumber(local.cidr_part3) + i}.${local.cidr_part4}/${var.subnet_cidr_block_ext}"]
}

resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr_block
    enable_dns_support = true #gives you an internal domain name
    enable_dns_hostnames = true #gives you an internal host name
    enable_classiclink = false
    instance_tenancy = "default"    
    
    tags = {
        Name = "${var.name}${local.environment_ext}"
    }
}

resource "aws_subnet" "this" {
    count = local.total_subnets
    vpc_id = aws_vpc.this.id
    cidr_block = length(var.subnet_cidr_blocks) == 0 ? local.auto_subnet_cidr_blocks[count.index] : var.subnet_cidr_blocks[count.index]
    map_public_ip_on_launch = (count.index + 1) <= var.num_public_subnets ? true : false // private/public
    assign_ipv6_address_on_creation = var.assign_subnets_ipv6_address_on_creation
    availability_zone = "${var.aws_region}${local.az_num_map[tostring((count.index + 1) % 3)]}"
    ipv6_cidr_block = length(var.subnet_ipv6_cidr_blocks) > 0 ? var.subnet_ipv6_cidr_blocks[count.index] : null
    tags = {
        Name = "${count.index + 1 <= var.num_public_subnets ? "public" : "private"}-subnet-${var.aws_region}${local.az_num_map[tostring((count.index + 1) % 3)]}${local.environment_ext}"
    }
}

resource "aws_internet_gateway" "this" {
    count = var.internet_gateway_count
    vpc_id = aws_vpc.this.id
    tags = {
        Name = "${var.name}-igw${local.environment_ext}"
    }
}

resource "aws_route_table" "this" {

    count = var.custom_route_table_count
    vpc_id = aws_vpc.this.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = var.route_table_igw_cidr_block
        //CRT uses this IGW to reach internet
        //hard coded becasue there shouldn't be more than one
        gateway_id = aws_internet_gateway.this[0].id
    }
    
    tags = {
        Name = "${var.name}-public-crt${local.environment_ext}"
    }
}

resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    count = var.num_public_subnets
    subnet_id = [for val in aws_subnet.this[*]: val if val.map_public_ip_on_launch == true][count.index].id
    route_table_id = var.custom_route_table_count > 0 ? aws_route_table.this[0].id : aws_vpc.this.default_route_table_id
}