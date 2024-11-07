# Firefly Azure Integration

![Firefly Logo](firefly.gif)

This repository contains Terraform modules for integrating Firefly with Azure subscriptions. It allows you to set up the necessary resources and permissions for Firefly to monitor and manage your Azure environment.

## Table of Contents

- [Firefly Azure Integration](#firefly-azure-integration)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Required Providers](#required-providers)
  - [Installation](#installation)
    - [Option 1: Discovered Subscriptions](#option-1-discovered-subscriptions)
    - [Option 2: Single/Selected Subscription](#option-2-singleselected-subscription)
  - [Required Resources](#required-resources)
  - [Configuration Variables](#configuration-variables)
  - [Contributing](#contributing)
  - [Support](#support)

## Prerequisites

Before you begin, ensure you have the following:

1. Terraform installed on your local machine
2. Azure CLI installed and configured
3. Necessary Azure credentials (see [Configuration Variables](#configuration-variables))
4. Firefly access and secret keys

## Required Providers

This module requires the following Terraform providers. Add this block to your Terraform configuration:

```hcl
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
```

Make sure to include this provider configuration in your Terraform files before using the Firefly Azure module.

## Installation

Choose one of the following installation options based on your needs:

### Option 1: Discovered Subscriptions

Use this option if you want Firefly to automatically discover and monitor all accessible Azure subscriptions.

```hcl
provider "azuread" {
  client_id     = var.client_id
  client_secret = var.client_secret
  tenant_id     = var.tenant_id
}

provider "azurerm" {
  features {}
  client_id                       = var.client_id
  client_secret                   = var.client_secret
  tenant_id                       = var.tenant_id
  subscription_id                 = var.subscription_id
  resource_provider_registrations = "none"
}

module "firefly_azure" {
  source  = "github.com/gofireflyio/terraform-firefly-azure-onboarding?ref=v1.1.0"
  
  client_id       = var.client_id
  client_secret   = var.client_secret
  directory_domain = "your-organization.com"
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
  
  firefly_access_key = var.firefly_access_key
  firefly_secret_key = var.firefly_secret_key
  
  location = var.location
  prefix   = var.prefix
  tags     = var.tags
  
  create_resource_provider_registration = false
  eventdriven_auto_discover = true
  eventdriven_enabled = true
  trigger_integrations = false
}
```

### Option 2: Single/Selected Subscription

Use this option if you want to integrate Firefly with specific Azure subscriptions. You'll need to create a separate module for each subscription.

```hcl
module "firefly_azure_subscription_1" {
  source  = "github.com/gofireflyio/terraform-firefly-azure-onboarding?ref=v1.1.0"
  
  client_id       = var.client_id
  client_secret   = var.client_secret
  directory_domain = "your-organization.com"
  tenant_id       = var.tenant_id
  subscription_id = "subscription-id-1"
  
  firefly_access_key = var.firefly_access_key
  firefly_secret_key = var.firefly_secret_key
  
  location = var.location
  prefix   = var.prefix
  tags     = var.tags
  
  create_resource_provider_registration = false
  eventdriven_auto_discover = false
  eventdriven_enabled = true
  trigger_integrations = false
}

# For additional subscriptions, create new modules and reference existing resources
module "firefly_azure_subscription_2" {
  source  = "github.com/gofireflyio/terraform-firefly-azure-onboarding?ref=v1.1.0"
  
  # ... (similar configuration as above)
  
  existing_resource_group_name = module.firefly_azure_subscription_1.firefly_resource_group_name
  existing_storage_account_id = module.firefly_azure_subscription_1.firefly_storage_account_id
  existing_eventgrid_topic_name = module.firefly_azure_subscription_1.firefly_eventgrid_system_topic_name
}
```

## Required Resources

The Terraform module will create the following Azure resources:

- Azure AD Application Registration
- Azure AD Service Principal
- Azure AD Service Principal Delegated Permission Grant
- Azure Event Grid System Topic
- Azure Event Grid System Topic Event Subscription
- Azure Monitor Diagnostic Setting
- Azure Resource Group
- Azure Resource Provider Registration
- Azure Role Assignment
- Azure Role Definition
- Azure Storage Account

## Configuration Variables

Service principal credential used must have permissions to create a service principal, assign permission to an application and create resources on the subscription that is added to Firefly. 

| Variable | Description |
|----------|-------------|
| `client_id` | Azure AD Application (client) ID |
| `client_secret` | Azure AD Application client secret |
| `tenant_id` | Azure AD Tenant ID |
| `subscription_id` | Azure Subscription ID |
| `firefly_access_key` | Firefly access key |
| `firefly_secret_key` | Firefly secret key |
| `directory_domain` | Your organization's domain (e.g., "yourcompany.com") |
| `location` | Azure region for resource deployment |
| `prefix` | Prefix for resource naming |
| `tags` | Tags to apply to created resources |

Ensure you have these variables set in your Terraform configuration or provide them securely using environment variables or a `terraform.tfvars` file.

For more detailed information on each variable and advanced configuration options, please refer to the module documentation.

## Contributing

We welcome contributions to the Firefly Azure Integration! If you have functionality that you think would be valuable to other Firefly customers, please feel free to submit a pull request.

When contributing, please:

1. Ensure your code is well-documented
2. Include a README or update the existing README with usage instructions
3. Test your code thoroughly before submitting

## Support

If you encounter any issues or have questions about using this repository, please open an issue on GitHub or contact Firefly support.

For more information about Firefly and our services, please visit [our website](https://www.gofirefly.io/).