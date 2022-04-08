provider "azurerm" {
  features {}
}

locals {
  application = "ops-vault"
  environment = random_integer.this.result
}

resource "random_integer" "this" {
  min = 0
  max = 32767
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.application}-${local.environment}"
  location = "northeurope"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${local.application}-${local.environment}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Free"
}

module "vault" {
  source = "../.."

  application = local.application
  environment = local.environment

  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

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
