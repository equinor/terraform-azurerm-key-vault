# Submodule for metric alerts

Terraform submodule which creates Azure Key Vault metric alert resources.

## Features

Metric alerts sent to given action group:

- Reduced availability

## Prerequisites

- Azure role `Contributor` at the resource group scope
- Azure role `Monitoring Contributor` at the action group scope

## Usage

```terraform
module "key_vault_metric_alerts" {
  source  = "equinor/key-vault/azurerm//modules/metric-alerts"

  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vault_id            = ""
  action_group_ids    = [azurerm_monitor_action_group.example.id]
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

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
