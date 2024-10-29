# route53.tf

# Create a Route 53 Hosted Zone (if you don't already have one)
resource "aws_route53_zone" "csye6225_zone" {
  name = var.domain_name # Use the variable for the domain name
}

# Create a Route 53 A Record for the EC2 instance
resource "aws_route53_record" "csye6225_ec2_a_record" {
  zone_id = aws_route53_zone.csye6225_zone.zone_id
  name    = var.subdomain_name # Use the variable for the subdomain
  type    = "A"
  ttl     = 60
  #   negative_ttl = 60

  # Get the public IP address of the EC2 instance
  records = [aws_instance.csye6225_ec2_instance.public_ip]

  # Ensure the A record is created only after the EC2 instance is up
  depends_on = [
    aws_instance.csye6225_ec2_instance
  ]
}
