resource "aws_vpc" "wl6vpc" {         # VPC
  enable_dns_support   = true
  enable_dns_hostnames = true
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "wl6vpc"
  }
}

data "aws_vpc" "default_vpc" {
  id = var.default_vpc_id
}

resource "aws_vpc_peering_connection" "vpc_peering" {
  vpc_id        = data.aws_vpc.default_vpc.id  
  peer_vpc_id   = aws_vpc.wl6vpc.id             
  auto_accept   = true  
}

resource "aws_route" "default_vpc_to_vpc" {
  route_table_id         = var.default_route_table_id  # Main route table ID of the default VPC
  destination_cidr_block = aws_vpc.wl6vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route" "public_to_default" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id

}

resource "aws_route" "private_to_default" {
  route_table_id = aws_route_table.private_route_table.id  # Replace with private route table ID
  destination_cidr_block = data.aws_vpc.default_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
resource "aws_subnet" "public_subnet_1" {     # Public Subnets in two Availability Zones
  vpc_id                  = aws_vpc.wl6vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "wl6sn - us-east-1a"
  }
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.wl6vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "wl6_pub_sn - us-east-1b"
  }
}


resource "aws_subnet" "private_subnet_1" {      # Private Subnets in two Availability Zones
  vpc_id            = aws_vpc.wl6vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "wl6_priv_sn - us-east-1a"
  }
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.wl6vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "wl6_priv_sn - us-east-1b"
  }
}

resource "aws_internet_gateway" "igw" {  # Internet Gateway
  vpc_id = aws_vpc.wl6vpc.id
  tags = {
    Name = "wl6_igw"
  }
}

resource "aws_eip" "eip" {               # Elastic IP
tags = {
    Name = "wl6_eip"
  }
depends_on = [ aws_internet_gateway.igw ]
}


resource "aws_nat_gateway" "nat_gw" {    # Nat Gateway
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "wl6_natgw"
  }
  depends_on = [aws_internet_gateway.igw]

}

resource "aws_eip" "eip_2" {               # Elastic IP for the second NAT Gateway
  tags = {
    Name = "wl6_eip_2"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw_2" {    # Second NAT Gateway
  allocation_id = aws_eip.eip_2.id
  subnet_id     = aws_subnet.public_subnet_2.id  # Attach to public subnet in us-east-1b

  tags = {
    Name = "wl6_natgw_2"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_route_table" { # Public Route Table
  vpc_id = aws_vpc.wl6vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
#  route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = "local"
#   }
  tags = {
    Name = "wl6_pub_rt"
  }
}
resource "aws_route_table" "private_route_table" { # Private Route Table
  vpc_id = aws_vpc.wl6vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }
#  route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = "local"
#   }
  tags = {
    Name = "wl6_priv_rt"
  }
}

resource "aws_route_table" "private_route_table_2" { # Private Route Table for us-east-1b
  vpc_id = aws_vpc.wl6vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "wl6_priv_rt_2"
  }
}

resource "aws_route_table_association" "public_rt_assoc" { # Public Route Table Association
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "private_rt_assoc" { # Private Route Table Association
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id

}

resource "aws_route_table_association" "private_rt_assoc_2" { # Associate with Private Subnet in us-east-1b
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table_2.id
}
