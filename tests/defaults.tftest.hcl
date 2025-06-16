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
    condition     = length(azurerm_key_vault.this.tags) == 0
    error_message = "Key Vault should not have any tags by default"
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
