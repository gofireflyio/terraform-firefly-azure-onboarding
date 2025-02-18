locals {
  filtered_subscriptions    = [for subscription in data.azurerm_subscriptions.current.subscriptions : subscription if !contains(keys(subscription.tags), "disable_firefly_discovery") && subscription.state == "Enabled"]
  kv_filtered_subscriptions = var.auto_discover_enabled && length(local.filtered_subscriptions) > 0 ? { for subscription in local.filtered_subscriptions : subscription.subscription_id => subscription.display_name } : { "${var.subscription_id}" = data.azurerm_subscription.current.display_name }

  resource_group_name = var.existing_resource_group_name != "" ? var.existing_resource_group_name : azurerm_resource_group.current[0].name
  storage_account_id  = var.existing_storage_account_id != "" ? var.existing_storage_account_id : azurerm_storage_account.current[0].id


  eventgrid_system_topic_name = var.existing_eventgrid_topic_name != "" ? var.existing_eventgrid_topic_name : azurerm_eventgrid_system_topic.current[0].name
  tags = merge(var.tags, {
    "firefly" = "true"
  })
}

module "naming" {
  source = "Azure/naming/azurerm"
}