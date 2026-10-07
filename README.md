# Terraform module for Azure Key Vault

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

  vault_name                 = "kv-contoso-dev"
  resource_group_name        = azurerm_resource_group.example.name
  location                   = azurerm_resource_group.example.location
  log_analytics_workspace_id = module.log_analytics.workspace_id

  network_acls_ip_rules = ["1.1.1.1/32", "2.2.2.2/32", "3.3.3.3/30"]

  private_endpoints = {
    "vault" = {
      name                   = "pep-contoso-vault-dev"
      subnet_id              = module.network.subnet_ids["private_endpoints"]
      private_dns_zone_ids   = [azurerm_private_dns_zone.blob_storage.id]
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "westeurope"
}

module "log_analytics" {
  source  = "equinor/log-analytics/azurerm"
  version = "~> 2.5"

  workspace_name      = "example-workspace"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

module "network" {
  source  = "equinor/network/azurerm"
  version = "~> 3.2"

  vnet_name           = "vnet-contoso-dev"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_spaces      = ["10.0.0.0/16"]

  subnets = {
    "private_endpoints" = {
      name             = "snet-private-endpoints"
      address_prefixes = ["10.0.1.0/24"]
    }
  }
}

resource "azurerm_private_dns_zone" "key_vault" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "key_vault" {
  name                  = "link-${module.network.vnet_name}"
  private_dns_zone_name = azurerm_private_dns_zone.key_vault.name
  resource_group_name   = azurerm_resource_group.example.name
  virtual_network_id    = module.network.vnet_id
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
