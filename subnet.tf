# Public Subnets
resource "aws_subnet" "dev_public_subnet" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  count                   =               local.az_count
  vpc_id                  = aws_vpc.csye6225_vpc.id
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "PublicSubnet-${count.index + 1}"
  }
}

# Private Subnets
resource "aws_subnet" "dev_private_subnets" {
  depends_on = [
    aws_vpc.csye6225_vpc,
  ]
  count             = local.az_count
  vpc_id            = aws_vpc.csye6225_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  tags = {
    Name = "PrivateSubnet-${count.index + 1}"
  }
}
