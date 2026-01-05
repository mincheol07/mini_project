data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# 2. 가져온 값 뒤에 붙은 줄바꿈 문자(\n)를 제거하고 /32를 붙여 변수화합니다.
locals {
  my_public_ip = "${chomp(data.http.my_ip.response_body)}/32"
}




# 인터넷 게이트웨이 생성
resource "aws_internet_gateway" "main_IGW" {
  vpc_id = var.vpc_id
  
  tags = {
    Name = "main-igw"
  }
}

/*# 인터넷 게이트웨이 vpc 연결
resource "aws_internet_gateway_attachment" "igw_attach" {
  internet_gateway_id = aws_internet_gateway.main_IGW.id
  vpc_id = var.vpc_id
  
}
*/

# eip elastic ip 생성
resource "aws_eip" "nat" {
  domain = "vpc"
}

# nat 게이트웨이 생성
resource "aws_nat_gateway" "main_NAT" {
  allocation_id = aws_eip.nat.id
  subnet_id = var.public_subnet_ids[0]
  
}

# 라우팅 테이블 생성 인터넷 게이트웨이 연결
resource "aws_route_table" "igw_rt" {
  vpc_id = var.vpc_id


  route {
    cidr_block = var.cidr_block_all
    gateway_id = aws_internet_gateway.main_IGW.id
  }
  
}

# 라우팅 테이블 생성 nat 게이트웨이 연결
resource "aws_route_table" "nat_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = var.cidr_block_all
    gateway_id = aws_nat_gateway.main_NAT.id
  }
  
}


resource "aws_route_table_association" "igw_connect" {
  count = length(var.public_subnet_ids)
  subnet_id = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.igw_rt.id
}


resource "aws_route_table_association" "nat_connect" {
  count = length(var.private_subnet_ids)
  subnet_id = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.nat_rt.id
  
}


resource "aws_security_group" "bastion_se_group" {
  name = "bastion_se_group"
  vpc_id = var.vpc_id
  
}

resource "aws_security_group" "web_se_group" {
  name = "web_se_group"
  vpc_id = var.vpc_id
}

resource "aws_security_group" "db_se_group" {
  name = "db_se_group"
  vpc_id = var.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "ssh_allow" {
  security_group_id = aws_security_group.bastion_se_group.id
  cidr_ipv4 = local.my_public_ip
  ip_protocol = var.ip_protocol_tcp
  from_port = 22
  to_port = 22
  
}



resource "aws_vpc_security_group_ingress_rule" "http_allow" {
  security_group_id = aws_security_group.web_se_group.id
  cidr_ipv4 = var.cidr_block_all
  ip_protocol = var.ip_protocol_tcp
  from_port = 80
  to_port = 80
}

resource "aws_vpc_security_group_ingress_rule" "tls_allow" {
  security_group_id = aws_security_group.web_se_group.id
  cidr_ipv4 = var.cidr_block_all
  ip_protocol = var.ip_protocol_tcp
  from_port = 443
  to_port = 443
  
}

resource "aws_vpc_security_group_ingress_rule" "db_allow" {
  security_group_id = aws_security_group.db_se_group.id
  for_each = toset(var.cidr_block_private_web)

  ip_protocol = var.ip_protocol_tcp
  cidr_ipv4 = each.key
  from_port = 3306
  to_port = 3306

  
}