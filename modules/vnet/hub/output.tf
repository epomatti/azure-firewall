output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "subnet_id" {
  value = azurerm_subnet.firewall.id
}

output "address_space" {
  value = azurerm_virtual_network.default.address_space
}
