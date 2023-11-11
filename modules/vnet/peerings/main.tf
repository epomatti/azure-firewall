# Hub to Spoke1
resource "azurerm_virtual_network_peering" "hub_to_spoke1" {
  name                      = "hub-to-spoke1"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.firewall_vnet_name
  remote_virtual_network_id = var.spoke1_vnet_id
}

resource "azurerm_virtual_network_peering" "spoke1_to_hub" {
  name                      = "spoke1-to-hub"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.spoke1_vnet_name
  remote_virtual_network_id = var.firewall_vnet_id
}
