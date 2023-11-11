output "firewall_private_ip" {
  value = azurerm_firewall.default.ip_configuration[0].private_ip_address
}

output "vm2_nat_public_ip" {
  value = azurerm_public_ip.nat_vm2.ip_address
}
