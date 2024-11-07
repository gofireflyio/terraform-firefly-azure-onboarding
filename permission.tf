locals {
  management_group_id = var.management_group_id != "" ? "/providers/Microsoft.Management/managementGroups/${var.management_group_id}" : data.azurerm_management_group.current.id
  scope               = var.eventdriven_auto_discover != "" ? local.management_group_id : "/subscriptions/${var.subscription_id}"
}

resource "azuread_application_registration" "current" {
  display_name = "${var.prefix}firefly${var.suffix}"
}

resource "azuread_service_principal" "current" {
  client_id = azuread_application_registration.current.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "current" {
  service_principal_id = azuread_service_principal.current.object_id
}

resource "azurerm_role_assignment" "BillingReader" {
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = "Billing Reader"
  scope                = local.scope
}

resource "azurerm_role_assignment" "Reader" {
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = "Reader"
  scope                = local.scope
}

resource "azurerm_role_assignment" "AppConfigurationDataReader" {
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = "App Configuration Data Reader"
  scope                = local.scope
}

resource "azurerm_role_assignment" "SecurityReader" {
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = "Security Reader"
  scope                = local.scope
}

resource "azurerm_role_definition" "Firefly" {
  name        = "${var.prefix}${module.naming.role_definition}Firefly${var.suffix}"
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
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = azurerm_role_definition.Firefly.name
  scope                = local.scope
}

resource "azuread_service_principal_delegated_permission_grant" "current" {
  service_principal_object_id          = azuread_service_principal.current.object_id
  resource_service_principal_object_id = azuread_service_principal.msgraph.object_id
  claim_values                         = ["Directory.Read.All"]
}
