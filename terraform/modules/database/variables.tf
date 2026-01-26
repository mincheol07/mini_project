


variable "db_password" {
  description = "db 패스워드"
  type = string
  sensitive = true
}

variable "db_subnet_group" {
  description = "db 서브넷 그룹"
  type = list(string)
  
}

variable "db_sg_group" {
  description = "db 보안 그룹"
  type = string
}