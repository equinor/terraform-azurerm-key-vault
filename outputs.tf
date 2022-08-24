output "vault_id" {
  description = "The ID of this Key vault."
  value       = azurerm_key_vault.this.id

  depends_on = [
    # Access policies should be created before managing Key Vault objects.
    azurerm_key_vault_access_policy.this
  ]
}

output "vault_uri" {
  description = "The URI of this Key vault."
  value       = azurerm_key_vault.this.vault_uri
}
