 resource "aws_db_instance" "main_db" {
    identifier = "main-db"
    engine = "mariadb"
    engine_version = "10.11"
    instance_class = "db.t3.micro"
    allocated_storage = 20

    storage_type = "gp3"

    db_name = "project_db"
    username = "admin"
    password = var.db_password
    db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
    vpc_security_group_ids = [  ]
    skip_final_snapshot = true
  
}




resource "aws_db_subnet_group" "db_subnet_group" {
    name = "main"
    subnet_ids = var.db_subnet_group
  
}
