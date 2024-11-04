output "vpc_id" {
  value = aws_vpc.csye6225_vpc.id
}

output "public_subnets" {
  value = aws_subnet.dev_public_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.dev_private_subnets.*.id
}


# Output the bucket name
# output "s3_bucket_name" {
#   value = aws_s3_bucket.csye6225_bucket.bucket
# }


output "subdomain_name" {
  value = var.subdomain_name
}

output "subdomain" {
  value = var.subdomain
}


output "a_record_name" {
  value = aws_route53_record.csye6225_ec2_a_record.name
}

# s3 bucket
output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}

# Output ASG details for reference (optional)
output "asg_id" {
  value = aws_autoscaling_group.csye6225_asg.id
}