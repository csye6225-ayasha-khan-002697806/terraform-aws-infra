# Create Internet Gateway
resource "aws_internet_gateway" "igw" {

  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  vpc_id = aws_vpc.csye6225_vpc.id
  tags = {
    Name = "dev-IGW"
  }
}