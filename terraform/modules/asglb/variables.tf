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

variable "security_group_web" {
    description = "웹 ec2 보안그룹"
    type = string
  
}

variable "vpc_id" {
    description = "vpc id"
    type = string
  
}


variable "auto_group_policy_var" {
    description = "오토스케일 그룹 정책 변수"
    type = object({
      name = string
      policy_type = string
      predefined_metric_type = string
      target_value = number

      
    })
  
}

variable "alb_var" {
    description = "alb 변수"
    type = object({
      name = string
      load_balancer_type = string
    })
  
}


variable "alb_target_group_var" {
    description = "alb 타겟 그룹 변수"
    type = object({
      name = string
      port = number
      protocol = string
      target_type = string

      path = string
      healthy_threshold = number
      unhealthy_threshold = number
      timeout = number
      interval = number
      matcher = string
    })
  
}

variable "alb_listener_var" {

    description = "alb 리스너"

    type = object({
      port = string
      protocol = string
      type = string
    })
  
}

variable "public_subnet_ids" {
    description = "퍼블릭 서브넷"
    type = list(string)
  
}