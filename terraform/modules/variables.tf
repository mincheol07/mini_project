# terraform/variables.tf
variable "db_password" {
  type      = string
  sensitive = true
}