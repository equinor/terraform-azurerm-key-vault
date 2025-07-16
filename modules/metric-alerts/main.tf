locals {
  parsed_vault_id     = provider::azurerm::parse_resource_id(var.vault_id)
  vault_name          = local.parsed_vault_id["resource_name"]
  resource_group_name = local.parsed_vault_id["resource_group_name"]
}

resource "azurerm_monitor_metric_alert" "reduced_availability" {
  name                = "Reduced availability - ${local.vault_name}"
  resource_group_name = local.resource_group_name
  scopes              = [var.vault_id]

  criteria {
    metric_namespace = "Microsoft.KeyVault/vaults"
    metric_name      = "Availability"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 100
  }

  frequency   = "PT1M"
  window_size = "PT5M"

  severity = 1 # Error

  dynamic "action" {
    for_each = var.action_group_ids

    content {
      action_group_id = action.value
    }
  }

  tags = var.tags
}
