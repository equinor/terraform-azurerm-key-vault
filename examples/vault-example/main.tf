locals {
  app_name         = "ops-vault"
  environment_name = "example"
}

data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.app_name}-${local.environment_name}"
  location = "norwayeast"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${local.app_name}-${local.environment_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Free"
  retention_in_days   = 7
}

module "vault" {
  source = "../.."

  name                       = "kv-${local.app_name}-${local.environment_name}"
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}

resource "azurerm_key_vault_secret" "this" {
  name         = "example-secret"
  value        = "super-secret-value"
  key_vault_id = module.vault.key_vault_id
}
