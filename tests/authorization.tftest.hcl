mock_provider "azurerm" {}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "authorization_defaults" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_deployment == false
    error_message = "Key Vault should not be enabled for deployment by default"
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_disk_encryption == false
    error_message = "Key Vault should not be enabled for disk encryption by default"
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_template_deployment == false
    error_message = "Key Vault should not be enabled for template deployment by default"
  }

  assert {
    condition     = length(azurerm_key_vault.this.access_policy) == 0
    error_message = "Key Vault should not have any access policies by default"
  }

  assert {
    condition     = azurerm_key_vault.this.enable_rbac_authorization == true
    error_message = "RBAC authorization should be enabled by default"
  }
}
