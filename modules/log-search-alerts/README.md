# Submodule for log search alerts

Terraform submodule which creates Azure Key Vault log search alert resources.

## Features

Log search alerts sent to given action group:

- Key near expiry
- Secret near expiry
- Certificate near expiry

## Prerequisites

- Azure role `Contributor` at the resource group scope
- Azure role `Monitoring Contributor` at the action group scope
- Log category `AuditEvent` enabled for the Key Vault to be monitored (enabled by default if the Key Vault was created using the root module)

## Usage

### Monitor all Key Vaults within subscription

```terraform
module "key_vault_log_search_alerts" {
  source  = "equinor/key-vault/azurerm//modules/log-search-alerts"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  scopes              = [data.azurerm_subscription.current.id]
  action_group_ids    = [azurerm_monitor_action_group.example.id]
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

data "azurerm_subscription" "current" {}

resource "azurerm_monitor_action_group" "example" {
  name                = "Example Alerts Action"
  resource_group_name = azurerm_resource_group.example.name
  short_name          = "ExampleAlerts"

  email_receiver {
    name          = "Ola Nordmann"
    email_address = "ola.nordmann@example.com"
  }
}
```
