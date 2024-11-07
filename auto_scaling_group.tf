# Auto Scaling Group
resource "aws_autoscaling_group" "csye6225_asg" {
  # Use the launch template you created
  launch_template {
    id      = aws_launch_template.csye6225_launch_template.id
    version = "$Latest"
    name    = "csye6225_asg"
  }

  # Auto Scaling configuration
  name             = "csye6225-asg"
  min_size         = var.asg_min_size
  max_size         = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  default_cooldown = var.asg_cool_down

  vpc_zone_identifier = [for subnet in aws_subnet.dev_public_subnet : subnet.id]

  # Health checks
  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Tagging for easy management
  tag {
    key                 = "Name"
    value               = "csye6225_asg_instance"
    propagate_at_launch = true
  }

  # ASG termination policies (optional)
  termination_policies = ["OldestInstance", "Default"]

  # Attach to load balancer if required
  target_group_arns = [aws_lb_target_group.csye6225_alb_tg.arn] # Assuming `alb_tg` is the target group created for your load balancer

  # Auto Scaling policies (if any)
  #   lifecycle {
  #     create_before_destroy = true
  #   }
}


