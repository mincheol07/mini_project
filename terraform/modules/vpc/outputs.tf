output "vpc_id" {
    description = "vpc id"
    value = aws_vpc.main-vpc.id
  
}


output "public_subnet" {
    description = "public 서브넷 내보내기"
    value = values(aws_subnet.public)[*].id  #values 붙이는 이유는 map 타입에서 list 형태로 타입변경
}

output "private_subnet" {
    description = "private 서브넷 내보내기"
    value = values(aws_subnet.private)[*].id
  
}