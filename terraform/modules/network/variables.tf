
# variables는 인풋이라고 생각하면됨 main에서 사용하기위한 변수를 정의하는 곳 실제값은 root의 main에서 지정함
# main에 vpc_id를 사용하기위해 입력 받는것
variable "vpc_id" {
    description = "vpc 입력받기"
    type = string
  
}

#
variable "public_subnet_ids" {
    description = "nat, igw 라우팅 테이블 연결을 위한 서브넷"
    type = list(string)
  
}

variable "private_subnet_ids" {
    description = "nat 라우팅 테이블 연결을 위한 서브넷"
    type = list(string)
  
}


variable "cidr_block" {
    description = "cidr 블록 지정"
    type = string
  
}