locals {
  scope = "/subscriptions/${var.subscription_id}"
}

resource "azuread_application_registration" "current" {
  count = var.existing_app_id != "" ? 0 : 1
  display_name = "spn-${var.prefix}firefly${var.suffix}"
}

resource "azuread_service_principal" "current" {
  count = var.existing_app_id != "" ? 0 : 1
  client_id = azuread_application_registration.current[0].client_id
  owners    = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "current" {
  service_principal_id = local.service_principle_object_id

}

resource "azurerm_role_assignment" "BillingReader" {
  principal_id         = local.service_principle_object_id
  role_definition_name = "Billing Reader"
  scope                = local.scope

}

resource "azurerm_role_assignment" "Reader" {
  principal_id         = local.service_principle_object_id
  role_definition_name = "Reader"
  scope                = local.scope

}

resource "azurerm_role_assignment" "AppConfigurationDataReader" {
  principal_id         = local.service_principle_object_id
  role_definition_name = "App Configuration Data Reader"
  scope                = local.scope

}

resource "azurerm_role_assignment" "SecurityReader" {
  principal_id         = local.service_principle_object_id
  role_definition_name = "Security Reader"
  scope                = local.scope

}

resource "azurerm_role_definition" "Firefly" {
  name        = "${module.naming.role_definition.name}-${var.prefix}Firefly${var.suffix}"
  scope       = local.scope
  description = "Firefly's requested permissions"

  permissions {
    actions = [
      "Microsoft.Storage/storageAccounts/listkeys/action",
      "Microsoft.DocumentDB/databaseAccounts/listConnectionStrings/action",
      "Microsoft.DocumentDB/databaseAccounts/listKeys/action",
      "Microsoft.DocumentDB/databaseAccounts/readonlykeys/action",
      "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action",
      "Microsoft.Web/sites/config/list/Action",
      "Microsoft.Cache/redis/listKeys/action",
      "Microsoft.AppConfiguration/configurationStores/ListKeys/action",
      "Microsoft.Search/searchServices/listQueryKeys/action",
      "Microsoft.Search/searchServices/listAdminKeys/action",
      "Microsoft.Authorization/roleAssignments/read",
      "Microsoft.OperationalInsights/workspaces/sharedkeys/action"
    ]
  }
  assignable_scopes = [
    local.scope
  ]
}

resource "azurerm_role_assignment" "Firefly" {
  principal_id         = local.service_principle_object_id
  role_definition_id   = azurerm_role_definition.Firefly.role_definition_resource_id
  scope                = local.scope
}
