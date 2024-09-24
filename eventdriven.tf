resource "azurerm_resource_group" "current" {
  count    = var.eventdriven_enabled ? 1 : 0
  location = var.location
  name     = "${var.prefix}firefly${var.suffix}"
  tags     = local.tags
}

resource "azurerm_storage_account" "current" {
  count                            = var.eventdriven_enabled ? 1 : 0
  account_replication_type         = "LRS"
  cross_tenant_replication_enabled = false
  account_tier                     = "Standard"
  location                         = var.location
  name                             = "${var.prefix != "" ? regex("\\w+", var.prefix) : ""}firefly${var.suffix != "" ? regex("\\w+", var.suffix) : ""}"
  resource_group_name              = azurerm_resource_group.current[0].name
  tags                             = local.tags
}

resource "azurerm_eventgrid_system_topic" "current" {
  count                  = var.eventdriven_enabled ? 1 : 0
  name                   = "${var.prefix}firefly${var.suffix}"
  location               = var.location
  resource_group_name    = azurerm_resource_group.current[0].name
  source_arm_resource_id = azurerm_storage_account.current[0].id
  topic_type             = "microsoft.storage.storageaccounts"
  tags                   = local.tags
}

resource "azurerm_eventgrid_system_topic_event_subscription" "current" {
  count                = var.eventdriven_enabled ? 1 : 0
  name                 = "${var.prefix}firefly${var.suffix}"
  resource_group_name  = azurerm_resource_group.current[0].name
  system_topic         = azurerm_eventgrid_system_topic.current[0].name
  included_event_types = ["Microsoft.Storage.BlobCreated"]

  webhook_endpoint {
    url                               = var.firefly_webhook_url
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }
  retry_policy {
    event_time_to_live    = 1440
    max_delivery_attempts = 30
  }
}

resource "azurerm_role_definition" "FireflyStorageAccountBlobReader" {
  count       = var.eventdriven_enabled ? 1 : 0
  name        = "${var.prefix}FireflyStorageAccountBlobReader-${var.subscription_id}${var.suffix}"
  scope       = "/subscriptions/${var.subscription_id}"
  description = "Firefly's requested permissions"

  permissions {
    data_actions = [
      "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read"
    ]
  }
  assignable_scopes = [
    "/subscriptions/${var.subscription_id}"
  ]
}

resource "azurerm_role_assignment" "FireflyStorageAccountBlobReader" {
  count                = var.eventdriven_enabled ? 1 : 0
  principal_id         = azuread_service_principal.current.id
  role_definition_name = azurerm_role_definition.FireflyStorageAccountBlobReader[0].name
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

resource "azurerm_monitor_diagnostic_setting" "current" {
  for_each           = var.eventdriven_enabled ? local.kv_filtered_subscriptions : {}
  name               = "${var.prefix}firefly${each.key}${var.suffix}"
  target_resource_id = "/subscriptions/${each.key}"
  storage_account_id = azurerm_storage_account.current[0].id
  enabled_log {
    category = "Administrative"
  }
  depends_on = [azurerm_storage_account.current[0]]
}