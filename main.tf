locals {
  tags = merge({ application = var.application, environment = var.environment }, var.tags)
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = coalesce(var.key_vault_name, "kv-${var.application}-${var.environment}")
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 90
  purge_protection_enabled   = var.purge_protection_enabled

  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  # Access policies MUST be created using the `azurerm_key_vault_access_policy` resource, to prevent conflicts.
  access_policy             = null
  enable_rbac_authorization = false

  tags = local.tags

  network_acls {
    bypass                     = "AzureServices"
    default_action             = length(var.firewall_ip_rules) == 0 && length(var.firewall_subnet_rules) == 0 ? "Allow" : "Deny"
    ip_rules                   = var.firewall_ip_rules
    virtual_network_subnet_ids = var.firewall_subnet_rules
  }
}

resource "azurerm_key_vault_access_policy" "this" {
  for_each = { for p in var.access_policies : p.object_id => p }

  key_vault_id            = azurerm_key_vault.this.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_id               = each.key
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
  key_permissions         = each.value.key_permissions
  storage_permissions     = []
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
