resource "azurerm_public_ip" "default" {
  name                = "pip-${var.workload}-firewall"
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

  # [Alert, Deny, Off]
  threat_intel_mode = var.threat_intel_mode

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.default.id
  }
}

resource "azurerm_firewall_policy" "policy_01" {
  name                = "afwp-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.policies_sku
}

# resource "azurerm_firewall_policy_rule_collection_group" "example" {
#   name               = "example-fwpolicy-rcg"
#   firewall_policy_id = azurerm_firewall_policy.example.id
#   priority           = 500

#   application_rule_collection {
#     name     = "app_rule_collection1"
#     priority = 500
#     action   = "Allow"

#     rule {
#       name = "app_rule_collection1_rule1"
#       protocols {
#         type = "Http"
#         port = 80
#       }
#       protocols {
#         type = "Https"
#         port = 443
#       }
#       source_addresses  = ["10.0.0.1"]
#       destination_fqdns = ["*.microsoft.com"]
#     }
#   }

#   network_rule_collection {
#     name     = "network_rule_collection1"
#     priority = 400
#     action   = "Deny"
#     rule {
#       name                  = "network_rule_collection1_rule1"
#       protocols             = ["TCP", "UDP"]
#       source_addresses      = ["10.0.0.1"]
#       destination_addresses = ["192.168.1.1", "192.168.1.2"]
#       destination_ports     = ["80", "1000-2000"]
#     }
#   }

#   nat_rule_collection {
#     name     = "nat_rule_collection1"
#     priority = 300
#     action   = "Dnat"
#     rule {
#       name                = "nat_rule_collection1_rule1"
#       protocols           = ["TCP", "UDP"]
#       source_addresses    = ["10.0.0.1", "10.0.0.2"]
#       destination_address = "192.168.1.1"
#       destination_ports   = ["80"]
#       translated_address  = "192.168.0.1"
#       translated_port     = "8080"
#     }
#   }
# }

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
