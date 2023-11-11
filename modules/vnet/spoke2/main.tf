locals {
  address_prefix = "10.20"
}

resource "azurerm_virtual_network" "default" {
  name                = "vnet-spoke2"
  address_space       = ["${local.address_prefix}.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "spoke2" {
  name                 = "subnet-spoke2"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["${local.address_prefix}.0.0/24"]
}
