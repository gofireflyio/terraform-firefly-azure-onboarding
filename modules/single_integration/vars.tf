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

variable "existing_service_principal_id" {
  type = string
  default = ""
}

variable "existing_app_id" {
  type = string
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

variable "subscription_name" {
  type = string
}

variable "is_prod" {
  type = bool
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
    "3.213.167.195",
    "54.146.252.237",
    "34.226.97.113"
  ]
}
