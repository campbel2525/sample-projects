# ---------------------------------------------
# VPC
# ---------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block                       = "10.0.0.0/16"
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = "vpc"
  }
}

# ---------------------------------------------
# Subnet
# ---------------------------------------------
resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false # trueにするとここに設置したec2にipが付与される

  tags = {
    Name = "public-subnet-1a"
    Type = "public"
  }
}

resource "aws_subnet" "public_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = false # trueにするとここに設置したec2にipが付与される

  tags = {
    Name = "public-subnet-1c"
    Type = "public"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1a"
  cidr_block              = "10.0.4.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-1a"
    Type = "private"
  }
}

resource "aws_subnet" "private_subnet_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "ap-northeast-1c"
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-subnet-1c"
    Type = "private"
  }
}

# ---------------------------------------------
# Internet Gatewayの設定
# route情報はaws_route_tableリソースで定義
# ---------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rtb"
    Type = "public"
  }
}

resource "aws_route_table_association" "public_rtb_to_public_subnet_1a" {
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = aws_subnet.public_subnet_1a.id
}

resource "aws_route_table_association" "public_rtb_to_public_subnet_1c" {
  route_table_id = aws_route_table.public_rtb.id
  subnet_id      = aws_subnet.public_subnet_1c.id
}

# ---------------------------------------------
# Nat Gatewayの設定 1a
# route情報はaws_route_tableリソースで定義
# ---------------------------------------------
resource "aws_nat_gateway" "ngw_1a" {
  allocation_id = aws_eip.ngw_eip_1a.id
  subnet_id     = aws_subnet.public_subnet_1a.id
  tags = {
    Name = "ngw-1a"
  }
}

resource "aws_eip" "ngw_eip_1a" {
  domain = "vpc"
  tags = {
    Name = "eip-1a"
  }
}

resource "aws_route_table" "private_rtb_1a" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1a.id
  }

  tags = {
    Name = "private-rtb-1a"
    Type = "private"
  }
}

resource "aws_route_table_association" "private_rtb_to_private_subnet_1a" {
  route_table_id = aws_route_table.private_rtb_1a.id
  subnet_id      = aws_subnet.private_subnet_1a.id
}

# ---------------------------------------------
# Nat Gatewayの設定 1c
# route情報はaws_route_tableリソースで定義
# ---------------------------------------------
resource "aws_nat_gateway" "ngw_1c" {
  allocation_id = aws_eip.ngw_eip_1c.id
  subnet_id     = aws_subnet.public_subnet_1c.id
  tags = {
    Name = "ngw-1c"
  }
}

resource "aws_eip" "ngw_eip_1c" {
  domain = "vpc"
  tags = {
    Name = "eip-1c"
  }
}

resource "aws_route_table" "private_rtb_1c" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1c.id
  }

  tags = {
    Name = "private-rtb-1c"
    Type = "private"
  }
}

resource "aws_route_table_association" "private_rtb_to_private_subnet_1c" {
  route_table_id = aws_route_table.private_rtb_1c.id
  subnet_id      = aws_subnet.private_subnet_1c.id
}
