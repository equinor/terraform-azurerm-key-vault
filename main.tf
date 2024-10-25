locals {
  metric_alerts = {
    "availability" = {
      name        = "Reduced availability"
      description = ""
      metric_name = "Availability"
      aggregation = "Average"
      operator    = "LessThan"
      threshold   = 100
      frequency   = "PT1M"
      window_size = "PT5M"
      severity    = 1 # Error
    }
  }
}

module "vault" {
  source = "./module/vault"

  vault_name                 = var.vault_name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_id = var.log_analytics_workspace_id

  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  access_policies           = var.access_policies
  enable_rbac_authorization = var.enable_rbac_authorization

  public_network_access_enabled           = var.public_network_access_enabled
  network_acls_default_action             = var.network_acls_default_action
  network_acls_bypass_azure_services      = var.network_acls_bypass_azure_services
  network_acls_ip_rules                   = var.network_acls_ip_rules
  network_acls_virtual_network_subnet_ids = var.network_acls_virtual_network_subnet_ids

  diagnostic_setting_name                      = var.diagnostic_setting_name
  diagnostic_setting_enabled_log_categories    = var.diagnostic_setting_enabled_log_categories
  diagnostic_setting_enabled_metric_categories = var.diagnostic_setting_enabled_metric_categories

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "this" {
  for_each = local.metric_alerts

  name                = "${each.value.name} - ${azurerm_key_vault.this.name}"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_key_vault.this.id]
  description         = each.value.description

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = each.value.metric_name
    aggregation      = each.value.aggregation
    operator         = each.value.operator
    threshold        = each.value.threshold
  }

  frequency   = each.value.frequency
  window_size = each.value.window_size
  severity    = each.value.severity

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}
