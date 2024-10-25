output "vault_id" {
  description = "The ID of this Key Vault."
  value       = module.vault.vault_id
}

output "vault_name" {
  description = "The name of this Key Vault."
  value       = module.vault.vault_name
}

output "vault_uri" {
  description = "The URI of this Key Vault."
  value       = module.vault.vault_uri
}
