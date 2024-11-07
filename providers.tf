terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }
  }
}

# provider "azuread" {
#   client_id     = var.client_id
#   client_secret = var.client_secret
#   tenant_id     = var.tenant_id
# }
#
# provider "azurerm" {
#   features {}
#   client_id                       = var.client_id
#   client_secret                   = var.client_secret
#   tenant_id                       = var.tenant_id
#   subscription_id                 = var.subscription_id
#   resource_provider_registrations = "none"
# }
