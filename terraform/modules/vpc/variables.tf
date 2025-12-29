variable "vpc_cidr" {
    description = "vpc 아이피 대역"
    type = string
    default = "10.0.0.0/16"
  
}

variable "vpc_region" {
    description = "vpc 리전"
    type = string
    default = "ap-northeast-2"
  
}


variable "vpc_az" {
    description = "vpc 가용영역"
    type = list(string)
}

variable "public_subnet" {
    description = "public 서브넷"
    type = object({
      az = string
      cidr = string
    })

}

variable "private_subnet" {
    description = "private 서브넷"
    type = object({
      az = string
      cidr = string
    })
}