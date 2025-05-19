# PRIMARY REGION VPC
resource "aws_vpc" "primary" {
  provider             = aws.primary
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "primary-vpc"
  }
}

resource "aws_vpc_dhcp_options" "primary" {
  provider            = aws.primary
  domain_name         = "ec2.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    Name = "primary-dhcp-options"
  }
}

resource "aws_vpc_dhcp_options_association" "primary" {
  provider        = aws.primary
  vpc_id          = aws_vpc.primary.id
  dhcp_options_id = aws_vpc_dhcp_options.primary.id
}

resource "aws_internet_gateway" "primary" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id
  tags = {
    Name = "primary-igw"
  }
}

resource "aws_subnet" "primary_public" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "primary-public-subnet"
  }
}

resource "aws_subnet" "primary_public_az2" {
  provider                = aws.primary
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "primary-public-subnet-az2"
  }
}

resource "aws_route_table" "primary_public" {
  provider = aws.primary
  vpc_id   = aws_vpc.primary.id
  tags = {
    Name = "primary-public-rt"
  }
}

resource "aws_route" "primary_internet_access" {
  provider               = aws.primary
  route_table_id         = aws_route_table.primary_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.primary.id
}

resource "aws_route_table_association" "primary_public" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_public.id
  route_table_id = aws_route_table.primary_public.id
}

resource "aws_route_table_association" "primary_public_az2" {
  provider       = aws.primary
  subnet_id      = aws_subnet.primary_public_az2.id
  route_table_id = aws_route_table.primary_public.id
}

# SECONDARY REGION VPC
resource "aws_vpc" "secondary" {
  provider             = aws.secondary
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "secondary-vpc"
  }
}

resource "aws_internet_gateway" "secondary" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id
  tags = {
    Name = "secondary-igw"
  }
}

resource "aws_subnet" "secondary_public" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.1.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "secondary-public-subnet"
  }
}

resource "aws_subnet" "secondary_public_az2" {
  provider                = aws.secondary
  vpc_id                  = aws_vpc.secondary.id
  cidr_block              = "10.1.2.0/24"
  availability_zone       = "us-west-2b"
  map_public_ip_on_launch = true
  tags = {
    Name = "secondary-public-subnet-az2"
  }
}

resource "aws_route_table" "secondary_public" {
  provider = aws.secondary
  vpc_id   = aws_vpc.secondary.id
  tags = {
    Name = "secondary-public-rt"
  }
}

resource "aws_route" "secondary_internet_access" {
  provider               = aws.secondary
  route_table_id         = aws_route_table.secondary_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.secondary.id
}

resource "aws_route_table_association" "secondary_public" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_public.id
  route_table_id = aws_route_table.secondary_public.id
}

resource "aws_route_table_association" "secondary_public_az2" {
  provider       = aws.secondary
  subnet_id      = aws_subnet.secondary_public_az2.id
  route_table_id = aws_route_table.secondary_public.id
}
