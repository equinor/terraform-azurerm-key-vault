locals {
  tenant_id = coalesce(var.tenant_id, data.azurerm_client_config.current.tenant_id)

  access_policies = [
    for p in var.access_policies : {
      tenant_id               = local.tenant_id
      application_id          = ""
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
  tenant_id           = local.tenant_id

  soft_delete_retention_days = var.soft_delete_retention_days
  purge_protection_enabled   = var.purge_protection_enabled

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment

  access_policy             = local.access_policies
  enable_rbac_authorization = var.enable_rbac_authorization

  public_network_access_enabled = var.public_network_access_enabled

  network_acls {
    default_action             = var.network_acls_default_action
    bypass                     = var.network_acls_bypass_azure_services ? "AzureServices" : "None"
    ip_rules                   = var.network_acls_ip_rules
    virtual_network_subnet_ids = var.network_acls_virtual_network_subnet_ids
  }

  tags = var.tags

  lifecycle {
    # Prevent accidental destroy of Key Vault.
    prevent_destroy = true
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # "log_analytics_destination_type" is unconfigurable for Key Vault.
  # Ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.65.0/docs/resources/monitor_diagnostic_setting#log_analytics_destination_type
  log_analytics_destination_type = null

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_enabled_log_categories)

    content {
      category = enabled_log.value
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(var.diagnostic_setting_enabled_metric_categories)

    content {
      category = enabled_metric.value
    }
  }
}
