variable "name" {}
variable "instance_count" { 
    type = number 
    default = 2 
}
variable "vm_size" { default = "Standard_B2s" }
variable "subnet_id" {}
variable "admin_username" {}
variable "admin_ssh_key" {}

resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.vm_size
  instances           = var.instance_count
  admin_username      = var.admin_username

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface {
    name    = "${var.name}-nic"
    primary = true
    ip_configuration {
      name      = "${var.name}-ipcfg"
      subnet_id = var.subnet_id
      primary   = true
    }
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
  }

  upgrade_mode = "Automatic"

  # extensibility: custom script extension to install app
  extension {
    name = "customScript"
    publisher = "Microsoft.Azure.Extensions"
    type = "CustomScript"
    type_handler_version = "2.1"
    settings = <<SETTINGS
      {
        "commandToExecute": "bash /tmp/install-${var.name}.sh"
      }
    SETTINGS
  }

  tags = {
    service = var.name
  }
}

output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.this.id
}
