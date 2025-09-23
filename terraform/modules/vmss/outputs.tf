output "vmss_id" {
  description = "ID del Virtual Machine Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.this.id
}

output "vmss_name" {
  description = "Nombre del Virtual Machine Scale Set"
  value       = azurerm_linux_virtual_machine_scale_set.this.name
}

output "private_ips" {
  description = "Lista de IPs privadas de las instancias del VMSS"
  value = [
    for nic in azurerm_linux_virtual_machine_scale_set.this.network_interface : nic.ip_configuration[0].private_ip_address
  ]
}
