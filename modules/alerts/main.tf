locals {
  parsed_vault_id     = provider::azurerm::parse_resource_id(var.vault_id)
  vault_name          = local.parsed_vault_id["resource_name"]
  resource_group_name = local.parsed_vault_id["resource_group_name"]

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

resource "azurerm_monitor_metric_alert" "this" {
  for_each = local.metric_alerts

  name                = "${each.value.name} - ${local.vault_name}"
  resource_group_name = local.resource_group_name
  scopes              = [var.vault_id]
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
