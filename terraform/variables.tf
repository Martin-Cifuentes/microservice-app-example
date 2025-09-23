variable "location" {
  type    = string
  default = "eastus"
}

variable "project_name" {
  type    = string
  default = "microservices-app"
}

variable "resource_group_name" {
  type    = string
  default = "${var.project_name}-rg"
}

variable "vnet_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_app_cidr" { default = "10.0.1.0/24" }
variable "subnet_lb_cidr"  { default = "10.0.2.0/24" }

variable "admin_username" {
  type    = string
  default = "azureuser"
}
variable "admin_ssh_key" {
  type        = string
  description = "public ssh key content"
}
