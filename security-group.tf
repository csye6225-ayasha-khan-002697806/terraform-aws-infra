# security-group.tf

resource "aws_security_group" "csye6225_lb_security_group" {
  name        = "load_balancer_security_group"
  description = "Security group for the Load Balancer"
  vpc_id      = aws_vpc.csye6225_vpc.id # Use the existing VPC ID here

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "load_balancer_security_group"
  }
}

# Application Security Group
resource "aws_security_group" "csye6225_security_group" {
  name        = "application-security-group"
  description = "Allow SSH, HTTP, HTTPS, and application port traffic"
  vpc_id      = aws_vpc.csye6225_vpc.id

  # Allow SSH from anywhere (for initial setup and testing)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.csye6225_lb_security_group.id]
  }

  # Allow HTTP traffic from anywhere
  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # # Allow HTTPS traffic from anywhere
  # ingress {
  #   from_port   = 443
  #   to_port     = 443
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # Allow custom application port traffic from anywhere
  ingress {
    from_port = var.app_port
    to_port   = var.app_port
    protocol  = "tcp"
    # cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.csye6225_lb_security_group.id]
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "application-security-group"
  }
}


# Security group for RDS
resource "aws_security_group" "csye6225_rds_security_group" {
  name        = "database-security-group"
  description = "Allow access to RDS instance"
  vpc_id      = aws_vpc.csye6225_vpc.id

  # Ingress rule to allow PostgreSQL traffic from EC2 instances
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.csye6225_security_group.id] # Allow only EC2 instances to connect
  }

  # Egress rule to allow all outbound traffic from RDS
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-security-group"
  }
}


# Listener for Load Balancer on Port 80
resource "aws_lb_listener" "csye6225_app_listener" {
  load_balancer_arn = aws_lb.csye6225_alb.arn
  port              = 80
  protocol          = var.tg_protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.csye6225_alb_tg.arn
  }
}
