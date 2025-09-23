# Terraform module for Azure Key Vault

[![GitHub License](https://img.shields.io/github/license/equinor/terraform-azurerm-key-vault)](https://github.com/equinor/terraform-azurerm-key-vault/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/equinor/terraform-azurerm-key-vault)](https://github.com/equinor/terraform-azurerm-key-vault/releases/latest)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-v1.0.0-%23FE5196?logo=conventionalcommits&logoColor=white)](https://conventionalcommits.org)

Terraform module which creates Azure Key Vault resources.

## Features

- Soft-delete retention set to 90 days by default.
- Purge protection enabled by default (see [notes](#purge-protection)).
- Role-based access control (RBAC) authorization enabled by default.
- Public network access denied by default.
- Audit logs sent to given Log Analytics workspace by default.

## Prerequisites

- Azure role `Contributor` at the resource group scope.
- Azure role `Log Analytics Contributor` at the Log Analytics workspace scope.

## Usage

```terraform
provider "azurerm" {
  features {}
}

module "key_vault" {
  source  = "equinor/key-vault/azurerm"
  version = "~> 11.11"

  vault_name                 = "example-vault"
  resource_group_name        = azurerm_resource_group.example.name
  location                   = azurerm_resource_group.example.location
  log_analytics_workspace_id = module.log_analytics.workspace_id

  network_acls_ip_rules = ["1.1.1.1/32", "2.2.2.2/32", "3.3.3.3/30"]
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

module "log_analytics" {
  source  = "equinor/log-analytics/azurerm"
  version = "~> 2.0"

  workspace_name      = "example-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}
```

## Notes

### Purge protection

Purge protection is enabled by default to protect against malicious or accidental deletion of secrets, as recommended in [Azure Key Vault best practices](https://learn.microsoft.com/en-us/azure/key-vault/general/best-practices#turn-on-data-protection-for-your-vault). Once purge protection has been enabled, it can't be disabled.

## Testing

1. Initialize working directory:

    ```bash
    terraform init
    ```

1. Execute tests:

    ```bash
    terraform test
    ```

    See [`terraform test` command documentation](https://developer.hashicorp.com/terraform/cli/commands/test) for options.

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).
