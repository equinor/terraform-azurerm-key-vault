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

  assert {
    condition     = length(azurerm_monitor_metric_alert.this) == 0
    error_message = "No metric alerts should be created by default"
  }
}

run "create_metric_alerts" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    action_group_ids = [run.setup_tests.action_group_id]
  }

  assert {
    condition     = length(azurerm_monitor_metric_alert.this) == 1
    error_message = "One metric alert should be created when action group IDs are provided"
  }

  assert {
    condition = alltrue([
      for metric_alert in azurerm_monitor_metric_alert.this : metric_alert.criteria[0].metric_namespace == "Microsoft.KeyVault/vaults"
    ])
    error_message = "Metric alerts should use the correct metric namespace for Key Vault"
  }

  assert {
    condition = alltrue([
      for metric_alert in azurerm_monitor_metric_alert.this : metric_alert.scopes == toset([azurerm_key_vault.this.id])
    ])
    error_message = "Metric alerts should be scoped to the Key Vault resource"
  }
}
