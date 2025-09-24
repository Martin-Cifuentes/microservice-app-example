variable "resource_group_name" {
  default = "microserviceapp-rg"
}
variable "location" {
  default = "eastus2"
}
variable "project_name" {
  default = "microserviceapp"
}
variable "backend_address_pool_id" {
  type    = string
  default = null
}
variable "name" {}
variable "instance_count" { default = 1 }
variable "vm_size" { default = "Standard_B1s" }
variable "subnet_id" {}
variable "admin_username" {}
variable "admin_ssh_key" {}

variable "enable_custom_script" {
  description = "Whether to enable custom script extension"
  type        = bool
  default     = false
}

variable "custom_script_uri" {
  description = "URI of the install script to run on VMSS instances"
  type        = string
  default     = ""
}

variable "custom_script_command" {
  description = "Command to execute for custom script"
  type        = string
  default     = ""
}