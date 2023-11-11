resource "azurerm_public_ip" "default" {
  name                = "pip-${var.workload}-firewall}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "default" {
  name                = "afw-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"

  # [Basic, Standard, Premium]
  sku_tier = var.sku_tier

  # [Alert,  Deny, Off]
  threat_intel_mode = var.threat_intel_mode

  ip_configuration {
    name                 = "firewall-${workload}"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.default.id
  }
}


### Monitor ###
resource "azurerm_monitor_diagnostic_setting" "default" {
  name                       = "firewall-monitor"
  target_resource_id         = azurerm_firewall.default.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AZFWNetworkRule"
  }

  enabled_log {
    category = "AZFWNatRule"
  }

  enabled_log {
    category = "AZFWApplicationRule"
  }

  metric {
    category = "AllMetrics"
  }
}
