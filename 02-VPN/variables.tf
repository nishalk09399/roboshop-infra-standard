variable "project_name" {
    default = "roboshop"
}


variable "env" {
    default = "dev"
}


variable "common_tags" {
  default = {
    Project = "roboshop"
    component = "VPN"
    Environment = "DEV"
    Terraform = "true"
  }
}