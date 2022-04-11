# terraform-azurerm-vault

Terraform module which creates an Azure Key Vault.

## Usage

```terraform
provider "azurerm" {
  features {}
}

locals {
  application = "my-app"
  environment = "example"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${local.application}-${local.environment}"
  location = "northeurope"
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "log-${local.application}-${local.environment}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Free"
}

module "vault" {
  source = "github.com/equinor/terraform-azurerm-vault"

  application = local.application
  environment = local.environment

  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}
```
