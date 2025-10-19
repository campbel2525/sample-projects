# ---------------------------------------------
# db_sg
# ---------------------------------------------
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "db-sg"
  }
}
resource "aws_security_group_rule" "db_in_app" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.app.id
}
resource "aws_security_group_rule" "db_out_all" {
  security_group_id = aws_security_group.db_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
# Lambdaからの入口を許可するルール
resource "aws_security_group_rule" "db_in_from_migration" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.migration_sg.id
  description              = "Allow access from migration security group"
}

# ---------------------------------------------
# app
# ---------------------------------------------
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "app role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "app-sg"
  }
}
resource "aws_security_group_rule" "app_out_all" {
  security_group_id = aws_security_group.app.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# ---------------------------------------------
# aws batch
# ---------------------------------------------
resource "aws_security_group" "migration_sg" {
  name        = "migration-sg"
  description = "Security group for AWS Batch"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "migration-sg"
  }
}
resource "aws_vpc_security_group_egress_rule" "batch_allow_all_outbound" {
  security_group_id = aws_security_group.migration_sg.id
  ip_protocol       = "-1"
  from_port         = 0
  to_port           = 0
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic for Batch instances"
}

# ---------------------------------------------
# ec2_sg
# ---------------------------------------------
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "database role security group"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "ec2-sg"
  }
}
resource "aws_security_group_rule" "ec2_out_all" {
  security_group_id = aws_security_group.ec2_sg.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
# ec2->db
resource "aws_security_group_rule" "db_in_tcp3306_from_ec2_sgr" {
  security_group_id        = aws_security_group.db_sg.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ec2_sg.id
}
