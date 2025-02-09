locals {
  resource_group_name = var.existing_resource_group_name != "" ? var.existing_resource_group_name : azurerm_resource_group.current[0].name
  storage_account_id = var.existing_storage_account_id != "" ? var.existing_storage_account_id : azurerm_storage_account.current[0].id
  app_id = var.existing_app_id != "" ? var.existing_app_id : azuread_application_registration.current[0].id
  service_principle_client_id = var.existing_service_principal_id != "" ? var.existing_service_principal_id : azuread_service_principal.current[0].client_id
  service_principle_object_id = var.existing_service_principal_id != "" ? data.azuread_service_principal.existing[0].object_id : azuread_service_principal.current[0].object_id
  eventgrid_system_topic_name = azurerm_eventgrid_system_topic.current[0].name
  tags = merge(var.tags, {
    "firefly" = "true"
  })
}

module "naming" {
  source = "Azure/naming/azurerm"
}