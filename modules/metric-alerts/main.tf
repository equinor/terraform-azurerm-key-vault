locals {
  parsed_vault_id     = provider::azurerm::parse_resource_id(var.vault_id)
  vault_name          = local.parsed_vault_id["resource_name"]
  resource_group_name = local.parsed_vault_id["resource_group_name"]
}

resource "azurerm_monitor_metric_alert" "reduced_availabilty" {
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

  action {
    action_group_id = var.action_group_id
  }

  tags = var.tags
}
