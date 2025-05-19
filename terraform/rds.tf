# 🔒 Security Group for RDS (Open for testing via 0.0.0.0/0)
resource "aws_security_group" "rds_sg" {
  provider    = aws.primary
  name        = "rds-sg"
  description = "Allow MySQL access"
  vpc_id      = aws_vpc.primary.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-sg"
  }
}

# 🛢️ DB Subnet Group for Primary Region
resource "aws_db_subnet_group" "primary" {
  provider = aws.primary
  name     = "primary-subnet-group"
  subnet_ids = [
    aws_subnet.primary_public.id,
    aws_subnet.primary_public_az2.id
  ]

  tags = {
    Name = "Primary RDS Subnet Group"
  }
}

# 🌐 Primary RDS Instance
resource "aws_db_instance" "primary" {
  provider                = aws.primary
  identifier              = "rds-primary"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  username                = "admin"
  password                = "Password123!" # Change this in production
  db_subnet_group_name    = aws_db_subnet_group.primary.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  skip_final_snapshot     = true
  publicly_accessible     = true
  multi_az                = false
  backup_retention_period = 1
  tags = {
    Name = "rds-primary"
  }
}

# 🛢️ DB Subnet Group for Replica Region
resource "aws_db_subnet_group" "replica" {
  provider = aws.secondary
  name     = "replica-subnet-group"
  subnet_ids = [
    aws_subnet.secondary_public.id,
    aws_subnet.secondary_public_az2.id
  ]

  tags = {
    Name = "Replica RDS Subnet Group"
  }
}

# 🌍 Replica RDS Instance
resource "aws_db_instance" "replica" {
  provider             = aws.secondary
  identifier           = "rds-replica"
  instance_class       = "db.t3.micro"
  engine               = "mysql"
  replicate_source_db  = aws_db_instance.primary.arn
  db_subnet_group_name = aws_db_subnet_group.replica.name
  publicly_accessible  = true
  skip_final_snapshot  = true
  tags = {
    Name = "rds-replica"
  }
}
