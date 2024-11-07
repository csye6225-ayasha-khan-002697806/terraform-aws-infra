# Application Load Balancer
resource "aws_lb" "csye6225_alb" {
  name               = "csye6225-alb"
  internal           = false
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.csye6225_lb_security_group.id]
  subnets            = [for subnet in aws_subnet.dev_public_subnet : subnet.id]

  tags = {
    Name = "csye6225-app-lb"
  }
}


