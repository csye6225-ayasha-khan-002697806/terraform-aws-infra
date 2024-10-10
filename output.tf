output "vpc_id" {
  value = aws_vpc.csye6225_vpc.id
}

output "public_subnets" {
  value = aws_subnet.dev_public_subnet.*.id
}

output "private_subnets" {
  value = aws_subnet.dev_private_subnets.*.id
}
