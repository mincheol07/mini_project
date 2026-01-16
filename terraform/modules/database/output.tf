
output "db_address" {
    value = aws_db_instance.main_db.address
  
}

output "db_username" {
    value = aws_db_instance.main_db.username
  
}

output "db_name" {
    value = aws_db_instance.main_db.db_name
  
}