output "key_vault_id" {
  value = azurerm_key_vault.this.id

  depends_on = [
    # Client must have access to the key vault before managing secrets
    azurerm_key_vault_access_policy.this
  ]
}

output "key_vault_name" {
  value = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  value = azurerm_key_vault.this.vault_uri
}

output "monitor_diagnostic_setting_id" {
  value = azurerm_monitor_diagnostic_setting.this.id
}
