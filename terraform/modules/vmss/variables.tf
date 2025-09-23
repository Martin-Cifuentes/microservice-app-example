variable "name" {}
variable "instance_count" { default = 2 }
variable "vm_size" { default = "Standard_B2s" }
variable "subnet_id" {}
variable "admin_username" {}
variable "admin_ssh_key" {}
