output "resource_group_name" {
  description = "Nombre del Resource Group creado"
  value       = azurerm_resource_group.rg.name
}

output "location" {
  description = "Región de despliegue"
  value       = azurerm_resource_group.rg.location
}

output "application_gateway_public_ip" {
  description = "IP pública del Application Gateway"
  value       = azurerm_public_ip.agw_pip.ip_address
}

output "redis_hostname" {
  description = "Hostname de Azure Cache for Redis"
  value       = azurerm_redis_cache.redis.hostname
}

output "redis_primary_key" {
  description = "Clave primaria de Redis (secreta, manejar con cuidado)"
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "ID del Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.la.id
}

# IDs de todos los VMSS desplegados (útil para autoscaling, monitorización, etc.)
output "vmss_ids" {
  description = "Lista de IDs de todos los Virtual Machine Scale Sets"
  value = [
    module.frontend.vmss_id,
    module.authapi.vmss_id,
    module.usersapi.vmss_id,
    module.todosapi.vmss_id,
    module.log_processor.vmss_id,
  ]
}

resource "azurerm_log_analytics_workspace" "la" {
  name                = "${var.project_name}-loganalytics"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
