# Azure Key Vault Terraform module

[![SCM Compliance](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-key-vault/badge)](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-key-vault/badge)
[![Equinor Terraform Baseline](https://img.shields.io/badge/Equinor%20Terraform%20Baseline-1.0.0-blueviolet)](https://github.com/equinor/terraform-baseline)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

Terraform module which creates an Azure Key Vault.

## Features

- Soft-delete retention set to 90 days by default.
- Purge protection disabled by default.
- Role-based access control (RBAC) authorization enabled by default.
- Public network access denied by default.
- Audit logs sent to given Log Analytics workspace by default.

## Prerequisites

- Install [Terraform](https://developer.hashicorp.com/terraform/install) **version 1.3 or higher**.
- Install [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
- Azure role `Contributor` at the resource group scope.

## Usage

1. Create a Terraform configuration file `main.tf` and add the following example configuration:

    ```terraform
    provider "azurerm" {
      features {}
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

    module "key_vault" {
      source  = "equinor/key-vault/azurerm"
      version = "~> 11.0"

      vault_name                 = "example-vault"
      resource_group_name        = azurerm_resource_group.example.name
      location                   = azurerm_resource_group.example.location
      log_analytics_workspace_id = module.log_analytics.workspace_id

      network_acls_ip_rules = ["1.1.1.1/32", "2.2.2.2/32", "3.3.3.3/30"]
    }
    ```

1. Install required provider plugins and modules:

    ```console
    terraform init
    ```

1. Apply Terraform configuration:

    ```console
    terraform apply
    ```

## Development

1. Read [this document](https://code.visualstudio.com/docs/devcontainers/containers).

1. Clone this repository.

1. Configure Terraform variables in a file `.devcontainer/devcontainer.env`:

    ```env
    TF_VAR_resource_group_name=
    TF_VAR_location=
    ```

1. Open repository in dev container.

## Testing

1. Change to the test directory:

    ```console
    cd test
    ```

1. Login to Azure:

    ```console
    az login
    ```

1. Set active subscription:

    ```console
    az account set -s <SUBSCRIPTION_NAME_OR_ID>
    ```

1. Run tests:

    ```console
    go test -timeout 60m
    ```

## Contributing

See [Contributing guidelines](https://github.com/equinor/terraform-baseline/blob/main/CONTRIBUTING.md).
