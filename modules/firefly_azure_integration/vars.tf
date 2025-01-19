variable "subscription_name" {
  type        = string
  description = "subscription_name"
}

variable "firefly_token" {
  type        = string
  description = "Token returned as result of login request, if provided firefly_access_key and firefly_secret_key are ignored"
}

variable "subscription_id" {
  type        = string
  description = "subscription id"
}


variable "firefly_endpoint" {
  type        = string
  description = "The Firefly endpoint to register account management"
  default     = "https://prodapi.gofirefly.io/api"
}

variable "is_prod" {
  type        = bool
  default     = false
  description = "Is Production?"
}

variable "tenant_id" {
  type = string
}

variable "application_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "directory_domain" {
  type = string
}

variable "eventdriven_enabled" {
  type    = bool
  default = true
}

variable "auto_discover_enabled" {
  type    = bool
  default = true
}

variable "iac_auto_discovery_disabled" {
  type    = bool
  default = false
}
