resource "azurerm_route_table" "spoke1" {
  name                          = "rt-spoke1"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name                   = "route-all-to-hub"
    address_prefix         = var.spoke2_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

resource "azurerm_route_table" "spoke2" {
  name                          = "rt-spoke2"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = false

  route {
    name                   = "route-all-to-hub"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "spoke1" {
  subnet_id      = var.spoke1_subnet_id
  route_table_id = azurerm_route_table.spoke1.id
}

resource "azurerm_subnet_route_table_association" "spoke2" {
  subnet_id      = var.spoke2_subnet_id
  route_table_id = azurerm_route_table.spoke2.id
}
