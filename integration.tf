data "http" "firefly_login" {
  count = var.firefly_secret_key != "" ? 1 : 0
  url    = "${var.firefly_endpoint}/account/access_keys/login"
  method = "POST"
  request_headers = {
    Content-Type = "application/json"
  }
  request_body = jsonencode({ "accessKey" = var.firefly_access_key, "secretKey" = var.firefly_secret_key })
}

locals {
  response_obj = try(jsondecode(data.http.firefly_login[0].response_body), {})
  token        = lookup(local.response_obj, "access_token", "error")
}

// Multi
module "firefly_integrate" {
  for_each         = local.kv_filtered_subscriptions
  firefly_endpoint = "https://api-eu.stag.firefly.ai/api"
  source           = "../modules/firefly_azure_integration"
  #firefly_token = local.token
  firefly_token               = local.token
  subscription_id             = each.key
  subscription_name           = each.value
  tenant_id                   = var.tenant_id
  application_id              = azuread_service_principal.current.client_id
  client_secret               = azuread_service_principal_password.current.value
  directory_domain            = "firefly"
  eventdriven_enabled         = var.eventdriven_enabled
  iac_auto_discovery_disabled = true
}