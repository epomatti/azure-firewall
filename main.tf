terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.79.0"
    }
  }
}

locals {
  workload = "bigenterprise"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = var.location
}

module "vnet_firewall" {
  source              = "./modules/vnet/hub"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "vnet_spoke1" {
  source              = "./modules/vnet/spoke1"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "vnet_spoke2" {
  source              = "./modules/vnet/spoke2"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}

module "peerings" {
  source              = "./modules/vnet/peerings"
  resource_group_name = azurerm_resource_group.default.name

  firewall_vnet_id   = module.vnet_firewall.vnet_id
  firewall_vnet_name = module.vnet_firewall.vnet_name

  spoke1_vnet_id   = module.vnet_spoke1.vnet_id
  spoke1_vnet_name = module.vnet_spoke1.vnet_name

  spoke2_vnet_id   = module.vnet_spoke2.vnet_id
  spoke2_vnet_name = module.vnet_spoke2.vnet_name
}


# resource "azurerm_log_analytics_workspace" "default" {
#   name                = "log-${local.workload}"
#   location            = azurerm_resource_group.default.location
#   resource_group_name = azurerm_resource_group.default.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }
