data "azurerm_management_group" "current" {
  name = var.tenant_id
}

data "azurerm_subscriptions" "current" {}
data "azuread_client_config" "current" {}
data "azurerm_subscription" "current" {
  subscription_id = var.subscription_id
}
data "azuread_application_published_app_ids" "well_known" {}

resource "azuread_service_principal" "msgraph" {
  client_id    = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
  use_existing = true
}
resource "azurerm_resource_provider_registration" "current" {
  count = var.create_resource_provider_registration ? 1 : 0
  name  = "microsoft.insights"
}
