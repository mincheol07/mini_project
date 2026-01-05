
resource "aws_vpc" "main-vpc" {
    cidr_block = var.vpc_cidr
    region = var.vpc_region
  
}

## 10.0.1.0/24, 10.0.2.0/24
resource "aws_subnet" "public" {
  for_each = var.public_subnet
  
  vpc_id            = aws_vpc.main-vpc.id

  availability_zone = each.value.az # 키로 사용하겠음
  cidr_block = each.value.cidr # 값으로 사용함
  map_public_ip_on_launch = true


  tags = {
    Name = "public-subnet-${each.key}"
  }
}

# 10.0.3.0, 10.0.4.0 10.0.5.0 10.0.6.0
resource "aws_subnet" "private" {

  for_each = var.private_subnet

  vpc_id = aws_vpc.main-vpc.id

  availability_zone = each.value.az
  cidr_block = each.value.cidr


  tags = {
    Name = "private-subnet-${each.key}"
  }
}