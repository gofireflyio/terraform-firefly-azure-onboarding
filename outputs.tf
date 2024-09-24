output "filtered_subscriptions" {
  value = local.kv_filtered_subscriptions
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

# output "firefly_storage_account_id" {
#   value = azurerm_storage_account.current[0].id
# }