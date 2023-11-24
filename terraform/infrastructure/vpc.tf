# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = "141.42.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}

# Create public subnets in each AZ
resource "aws_subnet" "public_subnets" {
  for_each = module.subnet_addrs.network_cidr_blocks

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.key
  cidr_block        = each.value
  map_public_ip_on_launch = true
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
 vpc_id = aws_vpc.vpc.id
}

# Create a route table
resource "aws_route_table" "rt" {
 vpc_id = aws_vpc.vpc.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.igw.id
 }
}

# Associate the route table with the public subnets
resource "aws_route_table_association" "public_subnet_asso" {
  for_each = aws_subnet.public_subnets

  route_table_id = aws_route_table.rt.id
  subnet_id      = each.value.id
}
