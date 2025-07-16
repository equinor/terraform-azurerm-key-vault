output "vault_name" {
  value = "kv-${local.name_suffix}"
}

output "resource_group_name" {
  value = "rg-${local.name_suffix}"
}

output "location" {
  value = "northeurope"
}

output "log_analytics_workspace_id" {
  value = "/subscriptions/${random_uuid.subscription_id.result}/resourceGroups/${local.resource_group_name}/providers/Microsoft.OperationalInsights/workspaces/log-${local.name_suffix}"
}

output "action_group_id" {
  value = "/subscriptions/${random_uuid.subscription_id.result}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Insights/actionGroups/ag-${local.name_suffix}"
}

output "tenant_id" {
  value = random_uuid.tenant_id.result
}
