
variable "public_subnet_ids" {
    description = "vpc에 있는 public 서브넷 목록"
    type = list(string)
  
}

variable "private_subnet_ids" {
    description = "vpc에 있는 private 서브넷 목록"
    type = list(string)
  
}

variable "ami_value" {
    description = "ami 값"
    type = string
  
}

variable "instance_type_value" {
    description = "ec2 타입"
    type = string
  
}

variable "security_group_web_id" {
    description = "web보안그룹"
    type = string
  
}

variable "security_group_bastion_id" {
    description = "bastion host sg"
    type = string
  
}


variable "db_password" { }
variable "db_address" { }
variable "db_username" { }
variable "db_name" { }