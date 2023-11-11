locals {
  address_prefix = "10.99"
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-firewall-hub"
  address_space       = ["${local.address_prefix}.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name

  # Recommended to use /26 for AzureFirewallSubnet
  address_prefixes = ["${local.address_prefix}.0.0/26"]
}
