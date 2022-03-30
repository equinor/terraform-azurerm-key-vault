provider "azurerm" {
  features {}
}

locals {
  app_name         = "ops-vault"
  environment_name = random_integer.this.result
}

resource "random_integer" "this" {
  min = 0
  max = 32767
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.app_name}-${local.environment_name}"
  location = "northeurope"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${local.app_name}-${local.environment_name}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Free"
}

module "vault" {
  source = "../.."

  app_name                   = local.app_name
  environment_name           = local.environment_name
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  client_permissions = {
    certificates = []
    keys         = []
    secrets      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  }
}

resource "azurerm_key_vault_secret" "this" {
  name         = "secret-name"
  value        = "super-secret-value"
  key_vault_id = module.vault.key_vault_id
}
