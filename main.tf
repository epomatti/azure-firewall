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

module "vm1" {
  source              = "./modules/vm"
  name                = "vm1"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet_spoke1.subnet_id
  size                = var.vm_size
}

module "vm2" {
  source              = "./modules/vm"
  name                = "vm2"
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
  subnet_id           = module.vnet_spoke2.subnet_id
  size                = var.vm_size
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = "log-${local.workload}"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_ip_group" "vnets" {
  name                = "ipgroup-vnet-space"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  cidrs = [
    module.vnet_firewall.address_space[0],
    module.vnet_spoke1.address_space[0],
    module.vnet_spoke2.address_space[0]
  ]
}

module "firewall" {
  source              = "./modules/firewall"
  workload            = local.workload
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  sku_tier          = var.firewall_sku_tier
  policies_sku      = var.firewall_policies_sku
  threat_intel_mode = var.firewall_threat_intel_mode

  firewall_subnet_id         = module.vnet_firewall.subnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.default.id
}

module "user_defined_routes" {
  source              = "./modules/vnet/routes"
  workload            = local.workload
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  spoke1_subnet_id    = module.vnet_spoke1.subnet_id
  spoke2_subnet_id    = module.vnet_spoke2.subnet_id
  firewall_private_ip = module.firewall.firewall_private_ip
}
