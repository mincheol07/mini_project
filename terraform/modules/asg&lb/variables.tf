variable "group_name" {

    description = "오토 스케일 그룹 이름"
    type = string
  
}

variable "group_max_size" {

    description = "ec2 생성 최대 사이즈"
    type = string
  
}

variable "group_min_size" {
    description = "ec2 생성 최소 사이즈"
    type = string
  
}

variable "group_desired_capacity" {
    description = "처음 ec2를 몇대 띄울지"
    type = string
  
}

variable "private_subnet_ids" {
    description = "private 서브넷 목록"
    type = list(string)
  
}

variable "launch_config" {
    description = "시작 템플릿"
    type = string
  
}