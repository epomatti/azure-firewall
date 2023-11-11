output "public_ip" {
  value = azurerm_public_ip.main.ip_address
}

output "asg_id" {
  value = azurerm_application_security_group.default.id
}

output "private_ip_address" {
  value = azurerm_network_interface.main.private_ip_address
}
