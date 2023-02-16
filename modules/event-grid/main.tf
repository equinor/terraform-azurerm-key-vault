resource "azurerm_eventgrid_system_topic" "this" {
  name                   = var.system_topic_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_arm_resource_id = var.key_vault_id
  topic_type             = "Microsoft.KeyVault.vaults"
}

resource "azurerm_eventgrid_system_topic_event_subscription" "this" {
  for_each = var.event_subscriptions

  name                = each.value["name"]
  system_topic        = azurerm_eventgrid_system_topic.this.name
  resource_group_name = azurerm_eventgrid_system_topic.this.resource_group_name

  included_event_types = each.value["included_event_types"]

  azure_function_endpoint {
    function_id                       = each.value["azure_function_endpoint"]["function_id"]
    max_events_per_batch              = 1
    preferred_batch_size_in_kilobytes = 64
  }
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = "failure-logs"
  target_resource_id         = azurerm_eventgrid_system_topic.this.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "DeliveryFailures"
  }

  metric {
    category = "AllMetrics"
    enabled  = false

    retention_policy {
      days    = 0
      enabled = false
    }
  }
}
