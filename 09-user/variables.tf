variable "project_name" {
    default = "roboshop"
}


variable "env" {
    default = "dev"
}


variable "common_tags" {
  default = {
    Project = "roboshop"
    Component = "user"
    Environment = "DEV"
    Terraform = "true"
  }
}