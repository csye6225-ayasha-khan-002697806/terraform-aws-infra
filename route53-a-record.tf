# Data source to get the existing Route 53 Hosted Zone for the domain
data "aws_route53_zone" "existing_zone" {
  name         = var.subdomain_name # Use the root domain name here
  private_zone = false
}

# Create a Route 53 A Record for the EC2 instance in the existing hosted zone
resource "aws_route53_record" "csye6225_ec2_a_record" {
  zone_id = data.aws_route53_zone.existing_zone.zone_id # Automatically get the zone ID
  name    = ""                                          # This is just the subdomain
  type    = "A"
  ttl     = 60

  # Get the public IP address of the EC2 instance
  records = [aws_instance.csye6225_ec2_instance.public_ip]

  # Ensure the A record is created only after the EC2 instance is up
  depends_on = [
    aws_instance.csye6225_ec2_instance
  ]
}
