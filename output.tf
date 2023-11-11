output "vm1_public_ip" {
  value = module.vm1.public_ip
}

output "vm1_private_ip" {
  value = module.vm1.private_ip_address
}

output "vm2_private_ip" {
  value = module.vm2.private_ip_address
}

output "vm2_nat_public_ip" {
  value = module.firewall.vm2_nat_public_ip
}
