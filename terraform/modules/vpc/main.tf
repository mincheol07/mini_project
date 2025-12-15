
resource "aws_vpc" "main-vpc" {
    cidr_block = var.vpc_cidr
    region = var.vpc_region
  
}

## 10.0.1.0/24, 10.0.2.0/24
resource "aws_subnet" "public" {
  for_each = var.public_subnet
  
  vpc_id            = aws_vpc.main-vpc.id

  availability_zone = each.key # 키로 사용하겠음
  cidr_block = each.value # 값으로 사용함


  tags = {
    Name = "public-subnet-${each.value}"
  }
}


resource "aws_subnet" "private" {

  for_each = var.private_subnet

  vpc_id = aws_vpc.main-vpc.id

  availability_zone = each.key
  cidr_block = each.value


  tags = {
    Name = "private-subnet-${each.value}"
  }
}