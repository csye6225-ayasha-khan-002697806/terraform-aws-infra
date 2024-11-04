# Launch Template for EC2 Instances
resource "aws_launch_template" "csye6225_launch_template" {
  name          = "csye6225-launch-template"
  image_id      = var.ami_id # Custom AMI ID
  instance_type = "t2.micro" # Instance type

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
    }
  }

  # User data script
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello World!"
    echo "DATABASE=${var.db_name}" >> /opt/csye6225/.env
    echo "DB_USERNAME=${var.db_username}" >> /opt/csye6225/.env
    echo "DB_PASSWORD=${var.db_password}" >> /opt/csye6225/.env
    echo "DB_HOST=${aws_db_instance.csye6225_postgres_instance.address}" >> /opt/csye6225/.env
    echo "DB_PORT=${var.db_port}" >> /opt/csye6225/.env
    echo "S3_BUCKET_NAME=${aws_s3_bucket.s3_bucket.id}" >> /opt/csye6225/.env
    echo "AWS_REGION=${var.region}" >>/opt/csye6225/.env  

    # Example of passing values to the application
    export DB_NAME=${var.db_name}
    export DB_USERNAME=${var.db_username}
    export DB_PASSWORD=${var.db_password}
    export DB_HOSTNAME=${aws_db_instance.csye6225_postgres_instance.address}
    export DB_PORT=${var.db_port}
    export S3_BUCKET_NAME=${aws_s3_bucket.s3_bucket.id}
    export AWS_REGION=${var.region}

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

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "web-server-instance"
    }
  }
}
