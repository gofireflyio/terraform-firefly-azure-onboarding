resource "azuread_application_registration" "current" {
  display_name = "${var.prefix}firefly-${var.subscription_id}${var.suffix}"
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
  scope                = "/subscriptions/${var.subscription_id}"
}

resource "azurerm_role_assignment" "Reader" {
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = "Reader"
  scope                = "/subscriptions/${var.subscription_id}"
}

resource "azurerm_role_assignment" "AppConfigurationDataReader" {
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = "App Configuration Data Reader"
  scope                = "/subscriptions/${var.subscription_id}"
}

resource "azurerm_role_assignment" "SecurityReader" {
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = "Security Reader"
  scope                = "/subscriptions/${var.subscription_id}"
}

resource "azurerm_role_definition" "Firefly" {
  name        = "${var.prefix}Firefly-${var.subscription_id}${var.suffix}"
  scope       = "/subscriptions/${var.subscription_id}"
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
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read"
    ]
  }

  assignable_scopes = [
    "/subscriptions/${var.subscription_id}"
  ]
}

resource "azurerm_role_assignment" "Firefly" {
  principal_id         = azuread_service_principal.current.object_id
  role_definition_name = azurerm_role_definition.Firefly.name
  scope                = "/subscriptions/${var.subscription_id}"
  condition_version    = "2.0"
  condition            = <<-EOT
(
	(
		!(ActionMatches{'Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read'} AND NOT
	SubOperationMatches{'Blob.List'})
	)
OR
	(
		@Resource[Microsoft.Storage/storageAccounts/blobServices/containers/blobs:path] StringLike '*state'
	)
OR
	(
		@Resource[Microsoft.Storage/storageAccounts/blobServices/containers/blobs:path] StringLike '*.tfstateenv:*'
	)
)
EOT
}

resource "azuread_service_principal_delegated_permission_grant" "current" {
  service_principal_object_id          = azuread_service_principal.current.object_id
  resource_service_principal_object_id = azuread_service_principal.msgraph.object_id
  claim_values                         = ["Directory.Read.All"]
}