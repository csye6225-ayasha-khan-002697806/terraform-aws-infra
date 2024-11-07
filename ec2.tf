# # ec2.tf

# # Create EC2 Instance
# resource "aws_instance" "csye6225_ec2_instance" {

#   depends_on = [
#     aws_security_group.csye6225_security_group,
#     aws_db_instance.csye6225_postgres_instance # to ensure RDS is created before the EC2 instance
#   ]

#   ami           = var.ami_id
#   instance_type = var.instance_type
#   subnet_id     = element(aws_subnet.dev_public_subnet.*.id, 0)
#   # subnet_id              = aws_subnet.dev_public_subnet[0].id
#   vpc_security_group_ids = [aws_security_group.csye6225_security_group.id]
#   #   security_group_ids = [aws_security_group.csye6225_security_group.id]
#   iam_instance_profile = aws_iam_instance_profile.ec2_profile.id

#   # Block device configuration for root volume
#   root_block_device {
#     volume_size           = 25
#     volume_type           = "gp2"
#     delete_on_termination = true
#   }

#   # User data script to pass RDS configuration to the instance
#   user_data = <<-EOF
#     #!/bin/bash
#     echo "Hello World!"
#     echo "DATABASE=${var.db_name}" >> /opt/csye6225/.env
#     echo "DB_USERNAME=${var.db_username}" >> /opt/csye6225/.env
#     echo "DB_PASSWORD=${var.db_password}" >> /opt/csye6225/.env
#     echo "DB_HOST=${aws_db_instance.csye6225_postgres_instance.address}" >> /opt/csye6225/.env
#     echo "DB_PORT=${var.db_port}" >> /opt/csye6225/.env
#     echo "S3_BUCKET_NAME=${aws_s3_bucket.s3_bucket.id}" >> /opt/csye6225/.env  #  to set S3 bucket name
#     echo "AWS_REGION=${var.region}" >>/opt/csye6225/.env  


#     # Example of passing values to the application
#     export DB_NAME=${var.db_name}
#     export DB_USERNAME=${var.db_username}
#     export DB_PASSWORD=${var.db_password}
#     export DB_HOSTNAME=${aws_db_instance.csye6225_postgres_instance.address}
#     export DB_PORT=${var.db_port}
#     export S3_BUCKET_NAME=${aws_s3_bucket.s3_bucket.id}  # Export S3 bucket name as an environment variable
#     export AWS_REGION=${var.region}


#     # Display the contents of the .env file
#     echo "Contents of .env file:"
#     cat /opt/csye6225/.env

#     # Configure the Cloudwatch agent and restart it
#     sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
#     -a fetch-config \
#     -m ec2 \
#     -c file:/opt/csye6225/cloudwatch-config.json \
#     -s

#     echo "Cloudwatch configured"

#     # restart cloud watch agent
#     sudo systemctl restart amazon-cloudwatch-agent

#     # Start your web application (you might need to modify this depending on your app's setup)
#     sudo systemctl restart nodeApp.service
#   EOF

#   tags = {
#     Name = "web-server-instance"
#   }
# }
