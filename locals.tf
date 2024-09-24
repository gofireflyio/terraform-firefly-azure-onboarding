locals {
  filtered_subscriptions = [for subscription in data.azurerm_subscriptions.current.subscriptions : subscription if !contains(keys(subscription.tags), "disable_firefly_discovery") && subscription.state == "Enabled"]
  kv_filtered_subscriptions = var.trigger_integrations && length(local.filtered_subscriptions) > 0 ? { for subscription in local.filtered_subscriptions : subscription.subscription_id => subscription.display_name } : {}

  tags = merge(var.tags, {
    "firefly" = "true"
  })
}