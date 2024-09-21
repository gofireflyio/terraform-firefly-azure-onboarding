output "sp_firefly_client_id" {
  value = azuread_service_principal.current.client_id
}

output "sp_firefly_client_secret" {
  value = azuread_service_principal_password.current.value
}

output "firefly_tenant_id" {
  value = var.tenant_id
}

output "firefly_subscription_id" {
  value = var.subscription_id
}