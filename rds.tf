# rds.tf

# Create a PostgreSQL RDS Parameter Group
resource "aws_db_parameter_group" "csye6225_postgres_parameter_group" {
  name        = "csye6225-postgres-parameter-group"
  family      = "postgres13" # Ensure this matches your PostgreSQL version
  description = "Parameter group for CSYE6225 PostgreSQL RDS instance"

  # You can customize these parameters based on your application needs
  parameter {
    name  = "max_connections"
    value = "100"
  }

  parameter {
    name  = "work_mem"
    value = "4MB"
  }

  parameter {
    name  = "shared_buffers"
    value = "128MB"
  }

  # Add more parameters as needed
}

# Create a PostgreSQL RDS instance
resource "aws_db_instance" "csye6225_postgres_instance" {
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "postgres"
  engine_version          = "13.4"          # Match this with your PostgreSQL version
  instance_class          = "db.t4g.micro"  # Cheapest instance class
  identifier              = "csye6225"      # DB instance identifier
  username                = var.db_username # Master username
  password                = var.db_password # Master password
  db_name                 = "csye6225"      # Database name
  port                    = var.db_port     # PostgreSQL port
  publicly_accessible     = false           # Make this false for private access
  skip_final_snapshot     = true
  backup_retention_period = 7
  parameter_group_name    = aws_db_parameter_group.csye6225_postgres_parameter_group.name

  vpc_security_group_ids = [aws_security_group.csye6225_rds_security_group.id] # Security group for RDS
  db_subnet_group_name   = aws_db_subnet_group.csye6225_rds_subnet_group.name  # Use private subnet group for the RDS

  # Associate the parameter group with the RDS instance


  # Apply tags to the RDS instance
  tags = {
    Name = "csye6225-postgres-db"
    # Environment = var.environment
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "csye6225_rds_subnet_group" {
  name       = "csye6225-rds-subnet-group"
  subnet_ids = aws_subnet.dev_private_subnets.*.id # Ensure these are private subnets

  tags = {
    Name = "csye6225-rds-subnet-group"
  }
}
