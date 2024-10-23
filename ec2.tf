# ec2.tf

# Create EC2 Instance
resource "aws_instance" "csye6225_ec2_instance" {

  depends_on = [
    aws_security_group.csye6225_security_group,
    aws_db_instance.csye6225_postgres_instance # Ensure RDS is created before the EC2 instance
  ]

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = element(aws_subnet.dev_public_subnet.*.id, 0)
  # subnet_id              = aws_subnet.dev_public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.csye6225_security_group.id]
  #   security_group_ids = [aws_security_group.csye6225_security_group.id]

  # Block device configuration for root volume
  root_block_device {
    volume_size           = 25
    volume_type           = "gp2"
    delete_on_termination = true
  }

  # User data script to pass RDS configuration to the instance
  user_data = <<-EOF
    #!/bin/bash
    echo "Hello World!"
    echo "DATABASE=${var.db_name}" >> /opt/csye6225/.env
    echo "DB_USERNAME=${var.db_username}" >> /opt/csye6225/.env
    echo "DB_PASSWORD=${var.db_password}" >> /opt/csye6225/.env
    echo "DB_HOST=${aws_db_instance.csye6225_postgres_instance.address}" >> /opt/csye6225/.env
    echo "DB_PORT=${var.db_port}" >> /opt/csye6225/.env

    # Example of passing values to the application
    export DB_NAME=${var.db_name}
    export DB_USERNAME=${var.db_username}
    export DB_PASSWORD=${var.db_password}
    export DB_HOSTNAME=${aws_db_instance.csye6225_postgres_instance.address}
    export DB_PORT=${var.db_port}

    # Display the contents of the .env file
    echo "Contents of .env file:"
    cat /opt/csye6225/.env

    # Start your web application (you might need to modify this depending on your app's setup)
    sudo systemctl start nodeApp.service
  EOF

  tags = {
    Name = "web-server-instance"
  }
}
