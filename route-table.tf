# Public Route Table
resource "aws_route_table" "public_route_table" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]

  vpc_id = aws_vpc.csye6225_vpc.id
  tags = {
    Name = "DevPublicRouteTable"
  }
}

# Route for Public Route Table to Internet Gateway
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_route_association" {
  count          = 3
  subnet_id      = element(aws_subnet.dev_public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_route_table.id
}

# Private Route Table
resource "aws_route_table" "private_route_table" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]

  vpc_id = aws_vpc.csye6225_vpc.id
  tags = {
    Name = "PrivateRouteTable"
  }
}

# Associate Private Subnets with Private Route Table
resource "aws_route_table_association" "private_route_association" {
  count          = 3
  subnet_id      = element(aws_subnet.dev_private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_route_table.id
}
