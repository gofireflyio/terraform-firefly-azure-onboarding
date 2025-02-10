data "azuread_client_config" "current" {}


data "azuread_service_principal" "existing" {
  count = var.existing_service_principal_id != "" ? 1 : 0
  application_id = var.existing_service_principal_id
}

resource "azurerm_resource_provider_registration" "current" {
  count = var.create_resource_provider_registration ? 1 : 0
  name  = "microsoft.insights"
}
