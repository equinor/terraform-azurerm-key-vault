# Ref: https://learn.microsoft.com/en-us/azure/key-vault/general/alert#example-log-query-alert-for-near-expiry-certificates (2025-07-08)

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "secret_near_expiry" {
  name                = var.secret_near_expiry_alert_rule_name
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = var.vault_ids

  criteria {
    query = <<-QUERY
      AzureDiagnostics
        | where OperationName == "SecretNearExpiryEventGridNotification"
        | extend SecretExpire = unixtime_seconds_todatetime(eventGridEventProperties_data_EXP_d)
        | extend DaysTillExpire = datetime_diff("Day", SecretExpire, now())
        | project ResourceId, SecretName = eventGridEventProperties_subject_s, DaysTillExpire, SecretExpire
    QUERY

    time_aggregation_method = "Count" # TODO: aggregation granularity?
    resource_id_column      = "ResourceId"
    operator                = "GreaterThan"
    threshold               = 0

    # TODO: Ensure unique SecretName + DaysTillExpire combinations will trigger separate alerts
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
    action_groups = var.action_group_ids
  }

  tags = var.tags
}
