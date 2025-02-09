data "azuread_client_config" "current" {}

data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}

data "azuread_service_principal" "existing" {
  count = var.existing_service_principal_id != "" ? 1 : 0
  application_id = var.existing_service_principal_id
}

resource "azurerm_resource_provider_registration" "current" {
  count = var.create_resource_provider_registration ? 1 : 0
  name  = "microsoft.insights"
}
