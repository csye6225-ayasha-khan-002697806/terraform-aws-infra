# Target Group for Auto Scaling Group instances
resource "aws_lb_target_group" "csye6225_alb_tg" {
  name        = "csye6225-target-group"
  target_type = var.lb_target_type
  port        = var.app_port
  protocol    = var.tg_protocol
  vpc_id      = aws_vpc.csye6225_vpc.id # Replace with your VPC ID

  health_check {
    path = "/healthz"
    # protocol = var.tg_protocol
    port     = var.app_port
    matcher  = "200"
    interval = 30
    timeout  = 10
    # healthy_threshold   = 2
    # unhealthy_threshold = 2
  }

  tags = {
    Name = "csye6225-target-group"
  }
}
