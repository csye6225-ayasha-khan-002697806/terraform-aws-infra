# Launch Template for EC2 Instances
resource "aws_launch_template" "csye6225_launch_template" {
  name          = "csye6225-launch-template"
  image_id      = var.ami_id        # Custom AMI ID
  instance_type = var.instance_type # Instance type

  # Optional: Use Key Pair for SSH access
  key_name = var.ssh_key_name # Replace with your SSH key name variable

  # Security group for the instance
  #   vpc_security_group_ids = [aws_security_group.csye6225_security_group.id]

  #   # Assign Public IP for accessibility
  #   network_interfaces {
  #     associate_public_ip_address = true
  #     subnet_id                   = element(aws_subnet.dev_public_subnet.*.id, 0)
  #   }

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [
      aws_security_group.csye6225_security_group.id,
    ]
  }

  # IAM instance profile for role-based access
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }

  disable_api_termination = false

  # Root volume configuration
  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 25
      volume_type           = "gp2"
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_kms_key.arn
    }
  }

  # User data script
  user_data = base64encode(<<-EOF
#!/bin/bash
echo "Hello World!"

# Update packages and install required utilities
sudo apt-get update -y
sudo apt-get install -y awscli jq

# Log message for debugging
echo "Fetching database credentials from AWS Secrets Manager..."

# Fetch the secret from AWS Secrets Manager
SECRET=$(aws secretsmanager get-secret-value --region ${var.region} --secret-id ${aws_secretsmanager_secret.db_secret.id} --query SecretString --output text)

# Extract values from the JSON secret
DB_PASSWORD=$(echo $SECRET | jq -r '.password')

# Write environment variables to the .env file
# echo "DATABASE=$DB_NAME" >> /opt/csye6225/.env
# echo "DB_USERNAME=$DB_USERNAME" >> /opt/csye6225/.env
echo "DB_PASSWORD=$DB_PASSWORD" >> /opt/csye6225/.env
# echo "DB_HOST=$DB_HOST" >> /opt/csye6225/.env
# echo "DB_PORT=$DB_PORT" >> /opt/csye6225/.env
echo "DATABASE=${var.db_name}" >> /opt/csye6225/.env
echo "DB_USERNAME=${var.db_username}" >> /opt/csye6225/.env
# # echo "DB_PASSWORD=${var.db_password}" >> /opt/csye6225/.env
# echo "DB_PASSWORD=${random_password.db_password.result}" >> /opt/csye6225/.env
echo "DB_HOST=${aws_db_instance.csye6225_postgres_instance.address}" >> /opt/csye6225/.env
echo "DB_PORT=${var.db_port}" >> /opt/csye6225/.env
echo "S3_BUCKET_NAME=${aws_s3_bucket.s3_bucket.id}" >> /opt/csye6225/.env
echo "AWS_REGION=${var.region}" >> /opt/csye6225/.env  
# Add SNS Topic ARN to the .env file
echo "SNS_TOPIC_ARN=${aws_sns_topic.user_signup_notification.arn}" >> /opt/csye6225/.env
echo "JWT_SECRET=${var.jwt_secret}" >> /opt/csye6225/.env

# Example of passing values to the application
export DB_NAME=${var.db_name}
export DB_USERNAME=${var.db_username}
# export DB_PASSWORD=${var.db_password}
# export DB_PASSWORD=${random_password.db_password.result}
export DB_HOSTNAME=${aws_db_instance.csye6225_postgres_instance.address}
export DB_PORT=${var.db_port}
# export DATABASE=$DB_NAME
# export DB_USERNAME=$DB_USERNAME
export DB_PASSWORD=$DB_PASSWORD
# export DB_HOSTNAME=$DB_HOST
# export DB_PORT=$DB_PORT
export S3_BUCKET_NAME=${aws_s3_bucket.s3_bucket.id}
export AWS_REGION=${var.region}
# Export the ARN as an environment variable for use in the application
export SNS_TOPIC_ARN=${aws_sns_topic.user_signup_notification.arn}

# Log message to confirm success
echo "Database credentials fetched and environment variables configured."

# Log for debugging
echo "SNS configuration added to environment variables"

# Display the contents of the .env file
echo "Contents of .env file:"
cat /opt/csye6225/.env

# Configure and restart the Cloudwatch agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/csye6225/cloudwatch-config.json \
-s

echo "Cloudwatch configured"

# Restart cloudwatch agent
sudo systemctl restart amazon-cloudwatch-agent

# Start the web application
sudo systemctl restart nodeApp.service
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server-instance"
    }
  }
}
