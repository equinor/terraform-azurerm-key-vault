
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # Version 3.20.0 is required to use the "azurerm_monitor_scheduled_query_rules_alert_v2" resource.
      version = ">= 3.20.0"
    }
  }
}
