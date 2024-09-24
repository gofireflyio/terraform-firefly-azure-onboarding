locals {
  filtered_subscriptions    = [for subscription in data.azurerm_subscriptions.current.subscriptions : subscription if !contains(keys(subscription.tags), "disable_firefly_discovery") && subscription.state == "Enabled"]
  kv_filtered_subscriptions = length(local.filtered_subscriptions) > 0 ? { for subscription in local.filtered_subscriptions : subscription.subscription_id => subscription.display_name } : { var.subscription_id = data.azurerm_subscription.current.display_name }

  tags = merge(var.tags, {
    "firefly" = "true"
  })
}