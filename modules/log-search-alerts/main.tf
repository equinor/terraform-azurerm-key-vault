resource "azurerm_monitor_scheduled_query_rules_alert_v2" "key_near_expiry" {
  name                = var.key_near_expiry_alert_rule_name
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = var.scopes

  criteria {
    query = <<-QUERY
      AzureDiagnostics
      | where OperationName == "KeyNearExpiryEventGridNotification"
      | extend KeyExpiryDatetime = unixtime_seconds_todatetime(eventGridEventProperties_data_EXP_d)
      | extend KeyExpiryDays = datetime_diff("Day", KeyExpiryDatetime, now())
      | project ResourceId, KeyName = eventGridEventProperties_subject_s, KeyExpiryDatetime, KeyExpiryDays
    QUERY

    time_aggregation_method = "Count"
    resource_id_column      = "ResourceId"
    operator                = "GreaterThan"
    threshold               = 0

    # Unique combinations of KeyName + KeyExpiryDays should trigger separate alerts.
    dimension {
      name     = "KeyName"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "KeyExpiryDays"
      operator = "Include"
      values   = ["*"]
    }
  }

  # Configure alert to run once per day, and evaluate logs from the entire previous day.
  evaluation_frequency = "P1D"
  window_duration      = "P1D"

  severity = 2 # Warning

  # Query validation fails during creation if no logs exist yet.
  skip_query_validation = true

  action {
    action_groups = var.action_group_ids
  }

  tags = var.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "secret_near_expiry" {
  name                = var.secret_near_expiry_alert_rule_name
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = var.scopes

  criteria {
    query = <<-QUERY
      AzureDiagnostics
      | where OperationName == "SecretNearExpiryEventGridNotification"
      | extend SecretExpiryDatetime = unixtime_seconds_todatetime(eventGridEventProperties_data_EXP_d)
      | extend SecretExpiryDays = datetime_diff("Day", SecretExpiryDatetime, now())
      | project ResourceId, SecretName = eventGridEventProperties_subject_s, SecretExpiryDatetime, SecretExpiryDays
    QUERY

    time_aggregation_method = "Count"
    resource_id_column      = "ResourceId"
    operator                = "GreaterThan"
    threshold               = 0

    # Unique combinations of SecretName + SecretExpiryDays should trigger separate alerts.
    dimension {
      name     = "SecretName"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "SecretExpiryDays"
      operator = "Include"
      values   = ["*"]
    }
  }

  # Configure alert to run once per day, and evaluate logs from the entire previous day.
  evaluation_frequency = "P1D"
  window_duration      = "P1D"

  severity = 2 # Warning

  # Query validation fails during creation if no logs exist yet.
  skip_query_validation = true

  action {
    action_groups = var.action_group_ids
  }

  tags = var.tags
}

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "certificate_near_expiry" {
  name                = var.certificate_near_expiry_alert_rule_name
  resource_group_name = var.resource_group_name
  location            = var.location
  scopes              = var.scopes

  criteria {
    query = <<-QUERY
      AzureDiagnostics
      | where OperationName == "CertificateNearExpiryEventGridNotification"
      | extend CertExpiryDatetime = unixtime_seconds_todatetime(eventGridEventProperties_data_EXP_d)
      | extend CertExpiryDays = datetime_diff("Day", CertExpiryDatetime, now())
      | project ResourceId, CertName = eventGridEventProperties_subject_s, CertExpiryDatetime, CertExpiryDays
    QUERY

    time_aggregation_method = "Count"
    resource_id_column      = "ResourceId"
    operator                = "GreaterThan"
    threshold               = 0

    # Unique combinations of CertName + CertExpiryDays should trigger separate alerts.
    dimension {
      name     = "CertName"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "CertExpiryDays"
      operator = "Include"
      values   = ["*"]
    }
  }

  # Configure alert to run once per day, and evaluate logs from the entire previous day.
  evaluation_frequency = "P1D"
  window_duration      = "P1D"

  severity = 2 # Warning

  # Query validation fails during creation if no logs exist yet.
  skip_query_validation = true

  action {
    action_groups = var.action_group_ids
  }

  tags = var.tags
}
