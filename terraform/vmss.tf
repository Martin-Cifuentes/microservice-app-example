module "frontend" {
  source         = "./modules/vmss"
  name           = "${var.project_name}-frontend"
  instance_count = 2
  vm_size        = "Standard_B2s"
  subnet_id      = azurerm_subnet.app.id
  admin_username = var.admin_username
  admin_ssh_key  = var.admin_ssh_key
}

module "authapi" {
  source         = "./modules/vmss"
  name           = "${var.project_name}-authapi"
  instance_count = 2
  vm_size        = "Standard_B1ms"
  subnet_id      = azurerm_subnet.app.id
  admin_username = var.admin_username
  admin_ssh_key  = var.admin_ssh_key
}

module "usersapi" {
  source = "./modules/vmss"
  name   = "${var.project_name}-usersapi"
  subnet_id      = azurerm_subnet.app.id
  admin_username = var.admin_username
  admin_ssh_key  = var.admin_ssh_key
}

module "todosapi" {
  source = "./modules/vmss"
  name   = "${var.project_name}-todosapi"
  subnet_id      = azurerm_subnet.app.id
  admin_username = var.admin_username
  admin_ssh_key  = var.admin_ssh_key
}

module "log_processor" {
  source = "./modules/vmss"
  name   = "${var.project_name}-logprocessor"
  instance_count = 1
  vm_size = "Standard_B1ms"
  subnet_id      = azurerm_subnet.app.id
  admin_username = var.admin_username
  admin_ssh_key  = var.admin_ssh_key
}
