output "public_ip" {
  value = var.create_public_ip ? azurerm_public_ip.main[0].ip_address : null
}

output "asg_id" {
  value = azurerm_application_security_group.default.id
}

output "private_ip_address" {
  value = azurerm_network_interface.main.private_ip_address
}
