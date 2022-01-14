output "subscription_id" {
  value = data.azurerm_client_config.this.subscription_id
}

output "key_vault_id" {
  value = module.vault.key_vault_id
}

output "monitor_diagnostic_setting_id" {
  value = module.vault.monitor_diagnostic_setting_id
}

output "key_vault_secret_name" {
  value = azurerm_key_vault_secret.this.name
}
