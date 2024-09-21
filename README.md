# Firefly Azure Subscription Integration

### Prerequisites

```
required providers
------------------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.53.1"
    }
  }
}

resources to be created
------------------------------------
azuread_application_registration
azuread_service_principal
azuread_service_principal_delegated_permission_grant
azurerm_eventgrid_system_topic
azurerm_eventgrid_system_topic_event_subscription
azurerm_monitor_diagnostic_setting
azurerm_resource_group
azurerm_resource_provider_registration
azurerm_role_assignment
azurerm_role_definition
azurerm_storage_account

credentials for the above resources
------------------------------------
client_id       = ""
client_secret   = ""
tenant_id       = ""
subscription_id = ""
```
### Installation

```hcl-terraform
module "firefly_azure_integration_00000000-0000-0000-0000-000000000000" {
  source              = "github.com/gofireflyio/terraform-firefly-azure-onboarding?ref=v1.0.0"
  client_id           = var.client_id
  client_secret       = var.client_secret
  tenant_id           = var.tenant_id
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  location            = var.location
  prefix              = "prefix-"
  suffix              = "-suffix"
  tags                = var.tags
  eventdriven         = true
}
output "sp_firefly_client_id_00000000-0000-0000-0000-000000000000" {
  value = module.firefly_azure_integration_00000000-0000-0000-0000-000000000000.sp_firefly_client_id
}
output "sp_firefly_client_secret_00000000-0000-0000-0000-000000000000" {
  value = nonsensitive(module.firefly_azure_integration_00000000-0000-0000-0000-000000000000.sp_firefly_client_secret)
}
output "firefly_tenant_id_id_00000000-0000-0000-0000-000000000000" {
  value = module.firefly_azure_integration_00000000-0000-0000-0000-000000000000.firefly_tenant_id
}
output "firefly_subscription_id_00000000-0000-0000-0000-000000000000" {
  value = module.firefly_azure_integration_00000000-0000-0000-0000-000000000000.firefly_subscription_id
}


module "firefly_azure_integration_11111111-1111-1111-1111-111111111111" {
  source              = "github.com/gofireflyio/terraform-firefly-azure-onboarding?ref=v1.0.0"
  client_id           = var.client_id
  client_secret       = var.client_secret
  tenant_id           = var.tenant_id
  subscription_id     = "11111111-1111-1111-1111-111111111111"
  location            = var.location
  prefix              = "prefix-"
  suffix              = "-suffix"
  tags                = var.tags
  eventdriven         = true
}
output "sp_firefly_client_id_11111111-1111-1111-1111-111111111111" {
  value = module.firefly_azure_integration_11111111-1111-1111-1111-1111111111110.sp_firefly_client_id
}
output "sp_firefly_client_secret_11111111-1111-1111-1111-111111111111" {
  value = nonsensitive(module.firefly_azure_integration_11111111-1111-1111-1111-111111111111.sp_firefly_client_secret)
}
output "firefly_tenant_id_id_11111111-1111-1111-1111-111111111111" {
  value = module.firefly_azure_integration_11111111-1111-1111-1111-111111111111.firefly_tenant_id
}
output "firefly_subscription_id_11111111-1111-1111-1111-111111111111" {
  value = module.firefly_azure_integration_11111111-1111-1111-1111-111111111111.firefly_subscription_id
}
```
