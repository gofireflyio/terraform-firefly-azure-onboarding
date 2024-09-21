resource "azurerm_resource_group" "current" {
  count    = var.eventdriven ? 1 : 0
  location = var.location
  name     = "${var.prefix}firefly${var.suffix}"
  tags     = local.tags
}

resource "azurerm_storage_account" "current" {
  count                            = var.eventdriven ? 1 : 0
  account_replication_type         = "LRS"
  cross_tenant_replication_enabled = false
  account_tier                     = "Standard"
  location                         = var.location
  name                             = "${var.prefix != "" ? regex("\\w+", var.prefix) : ""}firefly${var.suffix != "" ? regex("\\w+", var.suffix) : ""}"
  resource_group_name              = azurerm_resource_group.current[0].name
  tags                             = local.tags
}

resource "azurerm_resource_provider_registration" "current" {
  count = var.create_resource_provider_registration && var.eventdriven ? 1 : 0
  name  = "microsoft.insights"
}

resource "azurerm_monitor_diagnostic_setting" "current" {
  count              = var.eventdriven ? 1 : 0
  name               = "${var.prefix}firefly${var.suffix}"
  target_resource_id = "/subscriptions/${var.subscription_id}"
  storage_account_id = azurerm_storage_account.current[0].id
  enabled_log {
    category = "Administrative"
  }
}

resource "azurerm_eventgrid_system_topic" "current" {
  count                  = var.eventdriven ? 1 : 0
  name                   = "${var.prefix}firefly${var.suffix}"
  location               = var.location
  resource_group_name    = azurerm_resource_group.current[0].name
  source_arm_resource_id = azurerm_storage_account.current[0].id
  topic_type             = "microsoft.storage.storageaccounts"
  tags                   = local.tags
}

resource "azurerm_eventgrid_system_topic_event_subscription" "current" {
  count                = var.eventdriven ? 1 : 0
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
