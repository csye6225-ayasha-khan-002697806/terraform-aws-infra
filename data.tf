data "aws_availability_zones" "available" {
  state = "available"
}

# Set number of AZs to use (up to 3)
locals {
  az_count = min(3, length(data.aws_availability_zones.available.names))
}