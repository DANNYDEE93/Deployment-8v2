# VPC and Subnets
resource "aws_vpc" "app_vpc" {
  cidr_block = "172.28.0.0/16"
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "172.28.192.0/18"
  availability_zone = "us-east-1a"

  tags = {
    "Name" = "D8public | us-east-1a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "172.28.2.0/24"
  availability_zone = "us-east-1b"

  tags = {
    "Name" = "D8public | us-east-1b"
  }
}

# Other resources go here, such as Route Tables, Route Table Associations, EIPs, Gateways, Security Groups, etc.
