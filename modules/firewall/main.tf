resource "azurerm_public_ip" "default" {
  name                = "pip-${var.workload}-firewall"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  # Workaround as per documentation
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_public_ip" "nat_vm2" {
  name                = "pip-firewall-nat-vm2"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  # Workaround as per documentation
  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_firewall" "default" {
  name                = "afw-${var.workload}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  firewall_policy_id  = azurerm_firewall_policy.policy_01.id

  # Basic, Standard, Premium
  sku_tier = var.sku_tier

  # Alert, Deny, Off
  threat_intel_mode = var.threat_intel_mode

  ip_configuration {
    name                 = "ipconfig1"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.default.id
  }

  ip_configuration {
    name                 = "vm2-public-nat"
    public_ip_address_id = azurerm_public_ip.nat_vm2.id
  }
}

resource "azurerm_firewall_policy" "policy_01" {
  name                = "afwp-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.policies_sku
}

resource "azurerm_firewall_policy_rule_collection_group" "collection_group_terraform" {
  name               = "TerraformRuleCollectionGroup"
  firewall_policy_id = azurerm_firewall_policy.policy_01.id
  priority           = 500

  # application_rule_collection {
  #   name     = "app_rule_collection1"
  #   priority = 500
  #   action   = "Allow"

  #   rule {
  #     name = "app_rule_collection1_rule1"
  #     protocols {
  #       type = "Http"
  #       port = 80
  #     }
  #     protocols {
  #       type = "Https"
  #       port = 443
  #     }
  #     source_addresses  = ["10.0.0.1"]
  #     destination_fqdns = ["*.microsoft.com"]
  #   }
  # }

  network_rule_collection {
    name     = "AllowVNets"
    priority = 400
    action   = "Allow"

    rule {
      name                  = "AllowAllVNets"
      protocols             = ["Any"]
      source_ip_groups      = [var.vnet_ip_group_id]
      destination_ip_groups = [var.vnet_ip_group_id]
      destination_ports     = ["22", "80", "1000-2000"]
    }

    rule {
      name                  = "AllowSSH"
      protocols             = ["TCP"]
      source_addresses      = ["10.10.0.4"]
      destination_addresses = ["10.20.0.4"]
      destination_ports     = ["22", "80"]
    }

    rule {
      name                  = "Ping"
      protocols             = ["ICMP"]
      source_ip_groups      = [var.vnet_ip_group_id]
      destination_ip_groups = [var.vnet_ip_group_id]
      destination_ports     = ["*"]
    }
  }

  nat_rule_collection {
    name     = "NATVM2"
    priority = 300
    action   = "Dnat"

    rule {
      name                = "NATVM2"
      protocols           = ["TCP", "UDP"]
      source_addresses    = ["*"]
      destination_address = azurerm_public_ip.nat_vm2.ip_address
      destination_ports   = ["22"]
      translated_address  = var.vm2_private_ip_address
      translated_port     = "22"
    }
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
