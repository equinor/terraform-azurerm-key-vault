# Azure Key Vault Terraform module

[![SCM Compliance](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-key-vault/badge)](https://scm-compliance-api.radix.equinor.com/repos/equinor/terraform-azurerm-key-vault/badge)
[![Equinor Terraform Baseline](https://img.shields.io/badge/Equinor%20Terraform%20Baseline-1.0.0-blueviolet)](https://github.com/equinor/terraform-baseline)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org)

Terraform module which creates an Azure Key Vault.

## Features

- This module creates an Azure Key Vault with the following features:
  - Sets `standard` SKU.
  - Sets soft-delete retention period for `90` days, by default.
  - Disables purge protection, by default. Once enabled it cannot be disabled afterwards.
  - Option for retrieving secrets by other Azure services, is disabled by default.
  - Allows setting a list of access policies, empty by default.
  - Enables RBAC authorization, by default.
  - Enables public network access, by default.
  - Denies network ACL's, by default.
  - Enables Azure services to bypass network ACL's by default.
  - Enables audit logs for diagnostoc setting, and sends diagnostics to a Log Analytics Workspace.

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
