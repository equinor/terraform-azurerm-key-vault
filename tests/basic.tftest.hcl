mock_provider "azurerm" {}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "defaults" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id
  }

  assert {
    condition     = azurerm_key_vault.this.name == run.setup_tests.vault_name
    error_message = "Key Vault name should match the setup test vault name"
  }

  assert {
    condition     = azurerm_key_vault.this.resource_group_name == run.setup_tests.resource_group_name
    error_message = "Key Vault resource group should match the setup test resource group"
  }

  assert {
    condition     = azurerm_key_vault.this.location == run.setup_tests.location
    error_message = "Key Vault location should match the setup test location"
  }

  assert {
    condition     = azurerm_key_vault.this.sku_name == "standard"
    error_message = "Key Vault SKU should be standard by default"
  }

  assert {
    condition     = azurerm_key_vault.this.tenant_id == run.setup_tests.tenant_id
    error_message = "Key Vault tenant ID should match the setup test tenant ID"
  }

  assert {
    condition     = length(azurerm_key_vault.this.tags) == 0
    error_message = "Key Vault should not have any tags by default"
  }
}
