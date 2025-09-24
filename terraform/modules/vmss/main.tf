resource "azurerm_linux_virtual_machine_scale_set" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.vm_size
  instances           = var.instance_count
  admin_username      = var.admin_username

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
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
      load_balancer_backend_address_pool_ids = var.backend_address_pool_id != null ? [var.backend_address_pool_id] : null
    }
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.admin_ssh_key
  }

  upgrade_mode = "Automatic"

  dynamic "extension" {
    for_each = var.enable_custom_script ? [1] : []
    content {
      name                 = "customScript"
      publisher            = "Microsoft.Azure.Extensions"
      type                 = "CustomScript"
      type_handler_version = "2.1"
      settings = <<SETTINGS
        {
          "fileUris": ["${var.custom_script_uri}"],
          "commandToExecute": "${var.custom_script_command}"
        }
      SETTINGS
    }
  }

  tags = {
    service = var.name
  }
}