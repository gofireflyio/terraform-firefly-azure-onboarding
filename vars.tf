variable "firefly_endpoint" {
  type    = string
  default = "https://prodapi.firefly.ai/api"
}

variable "firefly_webhook_url" {
  type    = string
  default = "https://azure-events.firefly.ai"
}

variable "trigger_integrations" {
  type    = bool
  default = true
}

variable "firefly_access_key" {
  type        = string
  description = "Your authentication access_key"
  validation {
    condition     = var.firefly_access_key != ""
    error_message = "Variable \"firefly_access_key\" cannot be empty."
  }
}

variable "firefly_secret_key" {
  type        = string
  description = "Your authentication secret_key"
  validation {
    condition     = var.firefly_secret_key != ""
    error_message = "Variable \"firefly_secret_key\" cannot be empty."
  }
}

variable "directory_domain" {
  type = string
}

variable "location" {
  type    = string
  default = "eastus"
}


variable "prefix" {
  type    = string
  default = ""
}

variable "suffix" {
  type    = string
  default = ""
}

variable "existing_eventgrid_topic_name" {
  type    = string
  default = ""
}

variable "existing_resource_group_name" {
  type    = string
  default = ""
}

variable "existing_storage_account_id" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "create_resource_provider_registration" {
  type    = bool
  default = true
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "management_group_name" {
  type    = string
  default = ""
}

variable "auto_discover_enabled" {
  type    = bool
  default = true
}

variable "is_prod" {
  type    = bool
  default = false
}

variable "enforce_storage_network_rules" {
  type    = bool
  default = false
}

variable "firefly_eips" {
  type = list(string)
  default = [
    "3.224.145.192",
    "54.83.245.177",
    "34.226.97.113",
    "54.146.252.237",
    "3.213.167.195",
    "54.166.221.160",
    "52.22.128.83",
    "52.86.171.233",
    "34.200.154.87",
    "100.25.162.125",
    "18.209.82.232",
    "98.83.246.85",
    "54.144.58.153"
  ]
}

