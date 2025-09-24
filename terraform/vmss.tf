module "frontend" {
  source              = "./modules/vmss"
  name                = "${var.project_name}-frontend"
  instance_count      = 0
  vm_size             = "Standard_B1s"
  subnet_id           = azurerm_subnet.app.id
  admin_username      = var.admin_username
  admin_ssh_key       = var.admin_ssh_key
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_custom_script = false
}

module "authapi" {
  source              = "./modules/vmss"
  name                = "${var.project_name}-authapi"
  instance_count      = 1
  vm_size             = "Standard_B1s"
  subnet_id           = azurerm_subnet.app.id
  admin_username      = var.admin_username
  admin_ssh_key       = var.admin_ssh_key
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_custom_script = false
}

module "usersapi" {
  source              = "./modules/vmss"
  name                = "${var.project_name}-usersapi"
  instance_count      = 0
  vm_size             = "Standard_B1s"
  subnet_id           = azurerm_subnet.app.id
  admin_username      = var.admin_username
  admin_ssh_key       = var.admin_ssh_key
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_custom_script = false
}

module "todosapi" {
  source              = "./modules/vmss"
  name                = "${var.project_name}-todosapi"
  instance_count      = 0
  vm_size             = "Standard_B1s"
  subnet_id           = azurerm_subnet.app.id
  admin_username      = var.admin_username
  admin_ssh_key       = var.admin_ssh_key
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_custom_script = false
}

module "log_processor" {
  source              = "./modules/vmss"
  name                = "${var.project_name}-logprocessor"
  instance_count      = 1
  vm_size             = "Standard_B1s"
  subnet_id           = azurerm_subnet.app.id
  admin_username      = var.admin_username
  admin_ssh_key       = var.admin_ssh_key
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  enable_custom_script = false
}
