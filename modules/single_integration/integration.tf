data "http" "firefly_login" {
  count  = var.firefly_secret_key != "" ? 1 : 0
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

module "firefly_integrate" {
  count                       = var.trigger_integrations ? 1 : 0
  firefly_endpoint            = var.firefly_endpoint
  source                      = "./modules/firefly_azure_integration"
  firefly_token               = local.token
  subscription_id             = var.subscription_id
  subscription_name           = var.subscription_name
  tenant_id                   = var.tenant_id
  application_id              = local.service_principle_client_id
  client_secret               = azuread_service_principal_password.current.value
  directory_domain            = var.directory_domain
  auto_discover_enabled       = false
  is_prod                     = var.is_prod
}
