output "key_vault_id" {
  value = azurerm_key_vault.this.id

  depends_on = [
    # Client must have access to the key vault before managing secrets
    azurerm_key_vault_access_policy.this
  ]
}

output "monitor_diagnostic_setting_id" {
  value = azurerm_monitor_diagnostic_setting.this.id
}
