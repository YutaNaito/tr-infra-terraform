# ------------------------------------------------------------
# VPC
# ------------------------------------------------------------

resource "aws_vpc" "management_vpc" {
	cidr_block = "186.15.0.0/16"
	enable_dns_hostnames = true
	enable_dns_support = true
	
	tags = {
	  Name = "management-vpc"
	  Description = "For management"
	}
}

resource "aws_vpc" "app_vpc" {
	cidr_block = "72.107.0.0/16"
	enable_dns_hostnames = true
	enable_dns_support = true

	tags = {
	  Name = "app-vpc"
	  Description = "For remote controll management system"
	}
}


# ------------------------------------------------------------
# Subnet
# ------------------------------------------------------------

resource "aws_subnet" "management_public_subnet" {
	vpc_id = aws_vpc.management_vpc.id
	cidr_block = "186.15.10.0/24"
	map_public_ip_on_launch = true
	availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "app-public-subnet-a" {
	vpc_id = aws_vpc.app_vpc.id
	cidr_block = "72.107.1.0/24"
	map_public_ip_on_launch = true
	availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "app-public-subnet-b" {
	vpc_id = aws_vpc.app_vpc.id
	cidr_block = "72.107.3.0/24"
	map_public_ip_on_launch = true
	availability_zone = "ap-northeast-1b"
}

resource "aws_subnet" "app-private-subnet-c" {
	vpc_id = aws_vpc.main_vpc.id
	cidr_block = "72.107.2.0/24"
	map_public_ip_on_launch = false
	availability_zone = "ap-northeast-1c"
}

resource "aws_subnet" "app-private-subnet-d" {
	vpc_id = aws_vpc.main_vpc.id
	cidr_block = "72.107.4.0/24"
	map_public_ip_on_launch = false
	availability_zone = "ap-northeast-1d"
}


# ------------------------------------------------------------
# Internet gateway
# ------------------------------------------------------------

resource "aws_internet_gateway" "management_ig" {
	vpc_id = aws_vpc.management-vpc.id
}

resource "aws_internet_gateway" "app_ig" {
	vpc_id = aws_vpc.app_vpc.id  
}


# ------------------------------------------------------------
# Route table
# ------------------------------------------------------------

resource "aws_route_table" "management_route_table" {
  vpc_id = aws_vpc.management_vpc.id
}

resource "aws_route" "management_route" {
  route_table_id = aws_route_table.management_route_table.id
  gateway_id = aws_internet_gateway.management_ig.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "management_route_table_association" {
  subnet_id = aws_subnet.management_public_subnet.id
  route_table_id = aws_route_table.management_route_table.id
}

resource "aws_route_table" "app_public_route_table" {
  vpc_id = aws_vpc.app_vpc.id
}

resource "aws_route" "app_public_route" {
  route_table_id = aws_route_table.app_public_route_table.id
  gateway_id = aws_internet_gateway.app_ig.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "app_route_table_association" {
  subnet_id = aws_subnet.app-public-subnet-a
  route_table_id = aws_route_table.app_public_route_table
}