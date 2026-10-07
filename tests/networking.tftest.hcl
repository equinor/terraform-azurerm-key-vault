mock_provider "azurerm" {}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "networking_defaults" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id
  }

  assert {
    condition     = azurerm_key_vault.this.public_network_access_enabled == true
    error_message = "Public network access should be enabled by default"
  }

  assert {
    condition     = azurerm_key_vault.this.network_acls[0].default_action == "Deny"
    error_message = "Default action for network ACLs should be \"Deny\" by default"
  }

  assert {
    condition     = azurerm_key_vault.this.network_acls[0].bypass == "AzureServices"
    error_message = "Bypass for network ACLs should be set to \"AzureServices\" by default"
  }

  assert {
    condition     = length(azurerm_key_vault.this.network_acls[0].ip_rules) == 0
    error_message = "Key Vault should not have any IP rules by default"
  }

  assert {
    condition     = length(azurerm_key_vault.this.network_acls[0].virtual_network_subnet_ids) == 0
    error_message = "Key Vault should not have any virtual network subnet IDs by default"
  }

  assert {
    condition     = length(azurerm_private_endpoint.this) == 0
    error_message = "No private endpoints should be created by default"
  }
}

run "private_endpoints_empty" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    private_endpoints = {}
  }

  assert {
    condition     = length(azurerm_private_endpoint.this) == 0
    error_message = "No private endpoints should be created when the variable is empty"
  }
}

run "private_endpoints_defined" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    private_endpoints = {
      "example" = {
        name                 = "example-pep"
        subnet_id            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Network/virtualNetworks/example-vnet/subnets/private-endpoints-snet"
        private_dns_zone_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"]
      }
    }
  }

  assert {
    condition     = length(azurerm_private_endpoint.this) == 1
    error_message = "A private endpoint should be created when defined in the variable"
  }
}
