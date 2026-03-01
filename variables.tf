variable "db_password"{
  description = "RDS password"
  type=string
  sensitive = true
}
variable "db_username" {
  description = "admin username"
  type = string
  default = "vertex_admin"
}