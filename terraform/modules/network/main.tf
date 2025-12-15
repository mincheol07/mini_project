
# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "main_IGW" {
  vpc_id = var.vpc_id
  
  tags = {
    Name = "main-igw"
  }
}

# 인터넷 게이트웨이 vpc 연결
resource "aws_internet_gateway_attachment" "igw_attach" {
  internet_gateway_id = aws_internet_gateway.main_IGW.id
  vpc_id = var.vpc_id
  
}

# eip elastic ip 생성
resource "aws_eip" "nat" {
  domain = "vpc"
}

# nat 게이트웨이 생성
resource "aws_nat_gateway" "main_NAT" {
  allocation_id = aws_eip.nat.id
  subnet_id = var.public_subnet[0]
  
}

# 라우팅 테이블 인터넷 게이트웨이 연결
resource "aws_route_table" "igw_rt" {
  vpc_id = var.vpc_id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_IGW.id
  }
  
}


resource "aws_route_table" "nat" {
  
}