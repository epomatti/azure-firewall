variable "workload" {
  type = string
}

variable "firewall_subnet_id" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sku_tier" {
  type = string
}

variable "policies_sku" {
  type = string
}

variable "threat_intel_mode" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "vnet_ip_group_id" {
  type = string
}

variable "home_ip_group_id" {
  type = string
}
