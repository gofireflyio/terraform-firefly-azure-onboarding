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
### Installation with Discovered Subscriptions

```hcl-terraform

module "firefly_azure" {
  source = "github.com/gofireflyio/terraform-firefly-azure-onboarding?ref=v1.1.0"
  // get credentials from vault
  client_id     = var.client_id
  client_secret = var.client_secret

  directory_domain = "organization.com"
  tenant_id = var.tenant_id
  // firefly's landing subscription: eventgrid, storage_account and resource_group will be created here
  subscription_id = var.subscription_id
  
  // firefly credentials
  firefly_access_key = var.firefly_access_key
  firefly_secret_key = var.firefly_secret_key

  // custom settings
  location = var.location
  prefix   = var.prefix
  tags     = var.tags

  // create resource provider registration
  create_resource_provider_registration = false

  // enablew on all subscriptions that can be discovered
  eventdriven_auto_discover = true
  // enable eventdriven on subscription_id that was given
  eventdriven_enabled = true

  // create integrations
  trigger_integrations = false
}

```

### Installation with Single/Selected Subscription

```hcl-terraform
module "firefly_azure_00000000-0000-0000-0000-000000000000" {
  source = "github.com/gofireflyio/terraform-firefly-azure-onboarding?ref=v1.1.0"
  client_id     = var.client_id
  client_secret = var.client_secret

  directory_domain = "organization.com"
  tenant_id = var.tenant_id
  // firefly's landing subscription: eventgrid, storage_account and resource_group will be created here
  subscription_id = "00000000-0000-0000-0000-000000000000"
  
  // firefly credentials
  firefly_access_key = var.firefly_access_key
  firefly_secret_key = var.firefly_secret_key

  // custom settings
  location = var.location
  prefix   = var.prefix
  tags     = var.tags

  // create resource provider registration
  create_resource_provider_registration = false

  // enable on all subscriptions that can be discovered
  eventdriven_auto_discover = false
  // enable eventdriven on subscription_id that was given
  eventdriven_enabled = true

  // trigger integrations
  trigger_integrations = false
}

module "firefly_azure_10000000-0000-0000-0000-000000000000" {
  source = "github.com/gofireflyio/terraform-firefly-azure-onboarding?ref=v1.1.0"
  client_id     = var.client_id
  client_secret = var.client_secret

  directory_domain = "organization.com"
  tenant_id = var.tenant_id
  // firefly's landing subscription: eventgrid, storage_account and resource_group will be created here
  subscription_id = "10000000-0000-0000-0000-000000000000"
  
  // firefly credentials
  firefly_access_key = var.firefly_access_key
  firefly_secret_key = var.firefly_secret_key

  // custom settings
  location = var.location
  prefix   = var.prefix
  tags     = var.tags

  // create resource provider registration
  create_resource_provider_registration = false

  // enable on all subscriptions that can be discovered
  eventdriven_auto_discover = false
  // enable eventdriven on subscription_id that was given
  eventdriven_enabled = true

  // additional subscriptions require already created resources
  existing_resource_group_name = module.firefly_azure_00000000-0000-0000-0000-000000000000.firefly_resource_group_name
  existing_storage_account_id = module.firefly_azure_00000000-0000-0000-0000-000000000000.firefly_storage_account_id
  existing_eventgrid_topic_name = module.firefly_azure_00000000-0000-0000-0000-000000000000.firefly_eventgrid_system_topic_name

  // trigger integrations
  trigger_integrations = false
}
```
