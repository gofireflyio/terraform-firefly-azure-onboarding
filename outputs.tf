output "filtered_subscriptions" {
  value = var.eventdriven_auto_discover ? local.kv_filtered_subscriptions : {}
}

output "firefly_service_principal_id" {
  value = azuread_service_principal.current.id
}

output "firefly_tenant_id" {
  value = var.tenant_id
}

output "firefly_subscription_id" {
  value = var.subscription_id
}

output "firefly_resource_group_name" {
  value = local.resource_group_name
}

output "firefly_storage_account_id" {
  value = local.storage_account_id
}

output "firefly_eventgrid_system_topic_name" {
  value = local.eventgrid_system_topic_name
}
