output "vnet_id" {
  value = azurerm_virtual_network.default.id
}

output "vnet_name" {
  value = azurerm_virtual_network.default.name
}

output "subnet_spoke1_id" {
  value = azurerm_subnet.spoke2.id
}
