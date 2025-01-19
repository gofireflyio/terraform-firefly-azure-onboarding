data "http" "firefly_azure_integration_request" {
  url    = "${var.firefly_endpoint}/integrations/azure/"
  method = "POST"
  request_headers = {
    Content-Type  = "application/json"
    Authorization = "Bearer ${var.firefly_token}"
  }
  retry {
    attempts     = 3
    max_delay_ms = 5000
    min_delay_ms = 5000
  }
  request_body = jsonencode(
    {
      "name"                       = var.subscription_name,
      "subscriptionId"             = var.subscription_id,
      "tenantId"                   = var.tenant_id,
      "applicationId"              = var.application_id,
      "clientSecret"               = var.client_secret,
      "directoryDomain"            = var.directory_domain,
      "isProd"                     = var.is_prod,
      "isEventDriven"              = var.eventdriven_enabled,
      "isIacAutoDiscoveryDisabled" = var.iac_auto_discovery_disabled
      "isAutoDiscover"             = var.auto_discover_enabled
    }
  )
}
