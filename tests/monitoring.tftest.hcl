mock_provider "azurerm" {

  # Override values that are not known until after the plan is applied.
  override_during = plan

  override_resource {
    target = azurerm_key_vault.this
    values = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-resources/providers/Microsoft.KeyVault/vaults/example-vault"
    }
  }

  override_resource {
    target = azurerm_monitor_diagnostic_setting.this
    values = {
      log_analytics_destination_type = null
    }
  }
}

run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

run "monitoring_defaults" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id
  }

  assert {
    condition     = azurerm_monitor_diagnostic_setting.this.name == "audit-logs"
    error_message = "Diagnostic setting name should be \"audit-logs\" by default"
  }

  assert {
    condition     = azurerm_monitor_diagnostic_setting.this.target_resource_id == azurerm_key_vault.this.id
    error_message = "Diagnostic setting should be linked to the Key Vault resource"
  }

  assert {
    condition     = azurerm_monitor_diagnostic_setting.this.log_analytics_workspace_id == run.setup_tests.log_analytics_workspace_id
    error_message = "Diagnostic setting should be linked to the setup test Log Analytics workspace"
  }

  assert {
    condition     = azurerm_monitor_diagnostic_setting.this.log_analytics_destination_type == null
    error_message = "Diagnostic setting should not have a Log Analytics destination type configured for Key Vault"
  }

  assert {
    condition     = length(azurerm_monitor_diagnostic_setting.this.enabled_log) == 1 && tolist(azurerm_monitor_diagnostic_setting.this.enabled_log)[0].category == "AuditEvent"
    error_message = "Diagnostic setting should have \"AuditEvent\" log category enabled by default"
  }

  assert {
    condition     = length(azurerm_monitor_diagnostic_setting.this.enabled_metric) == 0
    error_message = "Diagnostic setting should not have any enabled metric categories by default"
  }
}
