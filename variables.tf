variable "location" {
  type = string
}

variable "firewall_sku_tier" {
  type = string
}

variable "firewall_threat_intel_mode" {
  type = string
}

variable "firewall_policies_sku" {
  type = string
}

variable "vm_size" {
  type = string
}

variable "home_cidrs" {
  type = list(string)
}
