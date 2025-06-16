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

run "enabled_for_deployment_true" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    enabled_for_deployment = true
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_deployment == true
    error_message = "Key Vault should be enabled for deployment"
  }
}

run "enabled_for_deployment_false" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    enabled_for_deployment = false
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_deployment == false
    error_message = "Key Vault should not be enabled for deployment"
  }
}

run "disk_encryption_enabled_true" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    enabled_for_disk_encryption = true
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_disk_encryption == true
    error_message = "Key Vault should be enabled for disk encryption"
  }
}

run "enabled_for_disk_encryption_false" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    enabled_for_disk_encryption = false
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_disk_encryption == false
    error_message = "Key Vault should not be enabled for disk encryption"
  }
}

run "enabled_for_template_deployment_true" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    enabled_for_template_deployment = true
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_template_deployment == true
    error_message = "Key Vault should be enabled for template deployment"
  }
}

run "enabled_for_template_deployment_false" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    enabled_for_template_deployment = false
  }

  assert {
    condition     = azurerm_key_vault.this.enabled_for_template_deployment == false
    error_message = "Key Vault should not be enabled for template deployment"
  }
}

run "access_policies_empty" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    access_policies = []
  }

  assert {
    condition     = length(azurerm_key_vault.this.access_policy) == 0
    error_message = "Key Vault should not have any access policies defined"
  }
}

run "access_policies_defined" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    access_policies = [
      {
        object_id               = "00000000-0000-0000-0000-000000000001"
        secret_permissions      = ["Get", "List", "Set", "Delete"]
        certificate_permissions = ["Get", "List", "Create", "Delete"]
        key_permissions         = ["Get", "List", "Create", "Delete"]
      },
      {
        object_id               = "00000000-0000-0000-0000-000000000002"
        secret_permissions      = ["Get", "List"]
        certificate_permissions = ["Get", "List"]
      },
      {
        object_id       = "00000000-0000-0000-0000-000000000003"
        key_permissions = ["Get", "List"]
      }
    ]
  }

  assert {
    condition     = length(azurerm_key_vault.this.access_policy) == 3
    error_message = "Key Vault should have 3 access policies defined"
  }
}

run "enable_rbac_authorization_true" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    enable_rbac_authorization = true
  }

  assert {
    condition     = azurerm_key_vault.this.enable_rbac_authorization == true
    error_message = "RBAC authorization should be enabled"
  }
}

run "enable_rbac_authorization_false" {
  command = plan

  variables {
    vault_name                 = run.setup_tests.vault_name
    resource_group_name        = run.setup_tests.resource_group_name
    location                   = run.setup_tests.location
    log_analytics_workspace_id = run.setup_tests.log_analytics_workspace_id
    tenant_id                  = run.setup_tests.tenant_id

    enable_rbac_authorization = false
  }

  assert {
    condition     = azurerm_key_vault.this.enable_rbac_authorization == false
    error_message = "RBAC authorization should not be enabled"
  }
}
