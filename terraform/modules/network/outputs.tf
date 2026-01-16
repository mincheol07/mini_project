output "web_se_group" {
    description = "웹 보안 그룹"
    value = aws_security_group.web_se_group.id
  
}

output "bastion_se_group" {
    description = "bastion 보안 그룹"
    value = aws_security_group.bastion_se_group.id
  
}

output "db_sg_group" {
    description = "db 보안 그룹"
    value = aws_security_group.db_se_group.id
  
}