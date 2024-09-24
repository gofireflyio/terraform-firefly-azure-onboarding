variable "firefly_endpoint" {
  type    = string
  default = "https://prodapi.firefly.io/api"
}

variable "firefly_webhook_url" {
  type    = string
  default = "https://azureevents.gofirefly.io"
}

variable "trigger_integrations" {
  type    = bool
  default = true
}

variable "iac_auto_discovery_disabled" {
  type = bool
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

variable "eventdriven_enabled" {
  type    = bool
  default = true
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

variable "management_group_id" {
  type    = string
  default = ""
}

variable "eventdriven_auto_discover" {}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}
