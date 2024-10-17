# ec2.tf

# Create EC2 Instance
resource "aws_instance" "csye6225_ec2_instance" {

  depends_on = [
    aws_security_group.csye6225_security_group,
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

  tags = {
    Name = "web-server-instance"
  }

}
