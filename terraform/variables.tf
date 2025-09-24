variable "location" {
  type    = string
  default = "eastus2"
}

variable "project_name" {
  type    = string
  default = "microservices-app"
}

variable "resource_group_name" {
  default = "microserviceapp-rg" // Usa un valor fijo o define en otro lado
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

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  sensitive   = true  
}
