output "key_vault_id" {
  description = "The ID of the Key Vault."
  value       = azurerm_key_vault.this.id

  depends_on = [
    # Current client must have access to the Key Vault before managing its contents.
    azurerm_key_vault_access_policy.this
  ]
}

output "key_vault_name" {
  description = "The name of the Key Vault."
  value       = azurerm_key_vault.this.name
}

output "key_vault_uri" {
  description = "The URI of the Key Vault."
  value       = azurerm_key_vault.this.vault_uri
}

output "monitor_diagnostic_setting_id" {
  description = "The ID of the Monitor Diagnostic Setting."
  value       = azurerm_monitor_diagnostic_setting.this.id
}
