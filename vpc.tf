# Create a VPC
resource "aws_vpc" "csye6225_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "dev-vpc"
  }
}

# # Create VPC
# resource "aws_vpc" "my_vpc" {
#   cidr_block = var.vpc_cidr
#   tags = {
#     Name = "MyVPC"
#   }
# }
