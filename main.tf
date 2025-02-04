locals {
  access_policies = [
    for p in var.access_policies : {
      tenant_id               = data.azurerm_client_config.current.tenant_id
      application_id          = ""
      object_id               = p.object_id
      secret_permissions      = p.secret_permissions
      certificate_permissions = p.certificate_permissions
      key_permissions         = p.key_permissions
      storage_permissions     = []
    }
  ]

  diagnostic_setting_metric_categories = ["AllMetrics"]
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                = var.vault_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "standard"
  tenant_id           = data.azurerm_client_config.current.tenant_id

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

  dynamic "metric" {
    for_each = toset(concat(local.diagnostic_setting_metric_categories, var.diagnostic_setting_enabled_metric_categories))

    content {
      # Azure expects explicit configuration of both enabled and disabled metric categories.
      category = metric.value
      enabled  = contains(var.diagnostic_setting_enabled_metric_categories, metric.value)
    }
  }
}

# Ref: https://learn.microsoft.com/en-us/azure/key-vault/general/alert#example-log-query-alert-for-near-expiry-certificates (2024-08-27)
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "secret_near_expiry" {
  name                = "Secret near expiry - ${azurerm_key_vault.this.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = [azurerm_key_vault.this.id]
  description         = "" # TODO

  criteria {
    query = <<-QUERY
    AzureDiagnostics
      | where OperationName == 'SecretNearExpiryEventGridNotification'
      | extend SecretExpire = unixtime_seconds_todatetime(eventGridEventProperties_data_EXP_d)
      | extend DaysTillExpire = datetime_diff("Day", SecretExpire, now())
      | project ResourceId, SecretName = eventGridEventProperties_subject_s, DaysTillExpire, SecretExpire
    QUERY

    time_aggregation_method = "Count" # TODO: aggregation granularity?
    resource_id_column      = "ResourceId"
    operator                = "GreaterThan"
    threshold               = 0

    # Ensure unique SecretName + DaysTillExpire combinations will trigger separate alerts
    dimension {
      name     = "SecretName"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "DaysTillExpire"
      operator = "Include"
      values   = ["*"]
    }
  }

  # Configure alert to run once per day, and evaluate logs from the entire previous day
  evaluation_frequency = "P1D" # TODO
  window_duration      = "P1D" # TODO

  severity = 2 # Warning

  # Sometimes fails during creation since no logs exist yet.
  # Skip that validation.
  skip_query_validation = true

  action {
    action_groups = [] # TODO
  }

  tags = var.tags
}
