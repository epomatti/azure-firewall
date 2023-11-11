output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "subnet_firewall_id" {
  value = azurerm_subnet.firewall.id
}

output "subnet_vms_id" {
  value = azurerm_subnet.vms.id
}
