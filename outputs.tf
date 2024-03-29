output "vault_id" {
  description = "The ID of this Key Vault."
  value       = azurerm_key_vault.this.id
}

output "vault_name" {
  description = "The name of this Key Vault."
  value       = azurerm_key_vault.this.name
}

output "vault_uri" {
  description = "The URI of this Key Vault."
  value       = azurerm_key_vault.this.vault_uri
}
