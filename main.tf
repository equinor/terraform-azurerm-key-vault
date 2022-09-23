locals {
  access_policies = [
    for p in var.access_policies : {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      object_id               = p.object_id
      secret_permissions      = p.secret_permissions
      certificate_permissions = p.certificate_permissions
      key_permissions         = p.key_permissions
      storage_permissions     = []
    }
  ]
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = var.vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 90
  purge_protection_enabled   = var.purge_protection_enabled

  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  # Access policies must be created using the `azurerm_key_vault_access_policy` resource, to prevent conflicts.
  access_policy             = local.access_policies
  enable_rbac_authorization = false

  tags = var.tags

  network_acls {
    bypass                     = "AzureServices"
    default_action             = length(var.firewall_ip_rules) == 0 && length(var.firewall_subnet_rules) == 0 ? "Allow" : "Deny"
    ip_rules                   = var.firewall_ip_rules
    virtual_network_subnet_ids = var.firewall_subnet_rules
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "${azurerm_key_vault.this.name}-logs"
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "AuditEvent"
    enabled  = true

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    enabled  = true

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
