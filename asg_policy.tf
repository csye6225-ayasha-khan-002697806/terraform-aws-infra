# Define the scale up policy
resource "aws_autoscaling_policy" "asg_scale_up" {
  name                   = "instance_scale_up_policy"
  scaling_adjustment     = 1 # Increment by 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.asg_cool_down # Cooldown period (in seconds)
  autoscaling_group_name = aws_autoscaling_group.csye6225_asg.name
}

# Define the scale down policy
resource "aws_autoscaling_policy" "asg_scale_down" {
  name                   = "instance_scale_down_policy"
  scaling_adjustment     = -1 # Decrement by 1 instance
  adjustment_type        = "ChangeInCapacity"
  cooldown               = var.asg_cool_down # Cooldown period (in seconds)
  autoscaling_group_name = aws_autoscaling_group.csye6225_asg.name
}

# Create CloudWatch Alarm for scale up
resource "aws_cloudwatch_metric_alarm" "scale_up_cpu_high_alarm" {
  alarm_name          = "Scale_up_alarm_for_high_CPU_Usage"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.scale_up_eval
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.scale_up_period # Check every minute
  statistic           = "Average"
  threshold           = var.scale_up_threshold # Trigger when CPU is above 5%
  alarm_description   = "Triggers when average CPU usage is above 5%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225_asg.name
  }

  # Specify the action to take when the alarm is triggered
  alarm_actions = [
    aws_autoscaling_policy.asg_scale_up.arn,
  ]
}

# Create CloudWatch Alarm for scale down
resource "aws_cloudwatch_metric_alarm" "scale_up_cpu_low_alarm" {
  alarm_name          = "Scale_up_alarm_for_low_CPU_Usage"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.scale_down_eval
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.scale_down_period # Check every minute
  statistic           = "Average"
  threshold           = var.scale_down_threshold # Trigger when CPU is below 3%
  alarm_description   = "Triggers when average CPU usage is below 3%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.csye6225_asg.name
  }

  # Specify the action to take when the alarm is triggered
  alarm_actions = [
    aws_autoscaling_policy.asg_scale_down.arn,
  ]
}
