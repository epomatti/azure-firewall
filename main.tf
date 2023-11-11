terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.79.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  workload = "pluralsight"
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload}"
  location = "eastus"
}

module "vnet" {
  source              = "./modules/vnet"
  workload            = local.workload
  resource_group_name = azurerm_resource_group.default.name
  location            = azurerm_resource_group.default.location
}


