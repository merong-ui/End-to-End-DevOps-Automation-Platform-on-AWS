# Create the VPC (an isolated network where I launch AWS resources)
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Create a Public Subnet (Where Jenkins & App will live)
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

# Create an Internet Gateway (The "Door" at my private network to the internet)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Create a Route Table (The "GPS" that tell data where to go.)
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# This connects Subnet to Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.rt.id
}