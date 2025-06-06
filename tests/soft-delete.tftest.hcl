mock_provider "azurerm" {}

override_data {
  target = data.azurerm_client_config.current
  values = {
    tenant_id = "90bf3c67-d9ec-4fb2-ade0-1141d5dd5bbf" # Randomly generated
  }
}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "purge_protection_default" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
  }

  assert {
    condition     = azurerm_key_vault.this.purge_protection_enabled == true
    error_message = "Purge protection should be enabled by default"
  }
}

run "purge_protection_enabled" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id

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

    purge_protection_enabled = false
  }

  assert {
    condition     = azurerm_key_vault.this.purge_protection_enabled == false
    error_message = "Unable to explicitly disable purge protection"
  }
}
