# Hub to Spoke1
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                         = "hub-to-spoke1"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.firewall_vnet_name
  remote_virtual_network_id    = var.spoke1_vnet_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                         = "spoke1-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.spoke1_vnet_name
  remote_virtual_network_id    = var.firewall_vnet_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

# Hub to Spoke2
resource "azurerm_virtual_network_peering" "hub_to_spoke2" {
  name                         = "hub-to-spoke2"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.firewall_vnet_name
  remote_virtual_network_id    = var.spoke2_vnet_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "spoke2_to_hub" {
  name                         = "spoke2-to-hub"
  resource_group_name          = var.resource_group_name
  virtual_network_name         = var.spoke2_vnet_name
  remote_virtual_network_id    = var.firewall_vnet_id
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}
