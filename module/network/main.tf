resource "aws_vpc" "main" {
	cidr_block = "10.0.0.0/16"
	enable_dns_hostnames = true
	enable_dns_support = true

	tags = {
	  "name" = "main"
	}
}

resource "aws_subnet" "public-subnet-a" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.1.0/24"
	map_public_ip_on_launch = true
	availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "public-subnet-b" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.3.0/24"
	map_public_ip_on_launch = true
	availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private-subnet-c" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.2.0/24"
	map_public_ip_on_launch = false
	availability_zone = "ap-northeast-1a"
}

resource "aws_subnet" "private-subnet-d" {
	vpc_id = aws_vpc.main.id
	cidr_block = "10.0.4.0/24"
	map_public_ip_on_launch = false
	availability_zone = "ap-northeast-1a"
}

resource "aws_internet_gateway" "main-ig" {
	vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main-rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "main-r" {
  route_table_id = aws_route_table.main-rt.id
  gateway_id = aws_internet_gateway.main-ig.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "main-rt-a" {
  subnet_id = aws_subnet.public-subnet-a.id
  route_table_id = aws_route_table.main-rt.id

}