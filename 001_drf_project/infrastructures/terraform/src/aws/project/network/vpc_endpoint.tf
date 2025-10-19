# ---------------------------------------------
# Vpc Endpoint
# private subnetに対してVPCエンドポイントを作成
# ---------------------------------------------

resource "aws_vpc_endpoint" "vpc_endpoint_ecr" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "ecr-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_dkr" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "ecr-dkr-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_ssm" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "ssm-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_ssm_messages" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "ssmmessages-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_ec2_messages" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ec2messages"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "ec2messages-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_cloudwatch_logs" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.logs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
  subnet_ids = [
    aws_subnet.private_subnet_1a.id,
    aws_subnet.private_subnet_1c.id
  ]

  private_dns_enabled = true

  tags = {
    Name = "cloudwatch-logs-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint_s3" {
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    aws_route_table.private_rtb_1a.id,
    aws_route_table.private_rtb_1c.id
  ]

  tags = {
    Name = "s3-vpc-endpoint"
  }
}

# ---------------------------------------------
# Security Group
# ---------------------------------------------
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "vpc endpoint role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "vpc-endpoint-sg"
  }
}

resource "aws_security_group_rule" "vpc_endpoint_sg_in_all" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["10.0.0.0/16"]
}


resource "aws_security_group_rule" "vpc_endpoint_sg_out_all" {
  security_group_id = aws_security_group.vpc_endpoint_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
