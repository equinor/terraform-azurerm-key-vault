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
      "pe1" = {
        name                          = "pe1"
        subnet_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/pe-subnet"
        custom_network_interface_name = "my-nic-1"
      }
      "pe2" = {
        name                          = "pe2"
        subnet_id                     = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-rg/providers/Microsoft.Network/virtualNetworks/my-vnet/subnets/pe-subnet"
        custom_network_interface_name = "my-nic-2"
      }
    }
  }

  assert {
    condition     = length(azurerm_private_endpoint.this) == 2
    error_message = "Two private endpoints should be created when the variable is defined with two entries"
  }

  assert {
    condition     = alltrue([for private_endpoint in azurerm_private_endpoint.this : private_endpoint.private_service_connection[0].is_manual_connection == false])
    error_message = "Private endpoints should not be created with manual connections when the Key Vault is owned by this module"
  }

  assert {
    condition     = alltrue([for private_endpoint in azurerm_private_endpoint.this : length(private_endpoint.private_service_connection) == 1 && private_endpoint.private_service_connection[0].subresource_names[0] == "vault"])
    error_message = "Private endpoints should be created with the \"vault\" subresource"
  }
}
