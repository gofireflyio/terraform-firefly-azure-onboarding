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

variable "eventdriven" {
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

variable "firefly_webhook_url" {
  type    = string
  default = "https://azureevents.gofirefly.io"
}

variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}
