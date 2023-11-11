locals {
  address_prefix = "10.10"
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-spoke1"
  address_space       = ["${local.address_prefix}.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "spoke1" {
  name                 = "subnet-spoke1"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${local.address_prefix}.0.0/24"]
}
