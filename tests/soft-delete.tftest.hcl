mock_provider "azurerm" {}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "soft_delete_retention" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    soft_delete_retention_days = 7
  }

  assert {
    condition     = azurerm_key_vault.this.soft_delete_retention_days == 7
    error_message = "Unable to explicitly set soft-delete retention (7 days)"
  }
}

run "purge_protection_enabled" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    purge_protection_enabled = true
  }

  assert {
    condition     = azurerm_key_vault.this.purge_protection_enabled == true
    error_message = "Unable to explicitly enable purge protection"
  }
}

run "purge_protection_disabled" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    purge_protection_enabled = false
  }

  assert {
    condition     = azurerm_key_vault.this.purge_protection_enabled == false
    error_message = "Unable to explicitly disable purge protection"
  }
}
