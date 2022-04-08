provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.application}-${var.environment}"
  location = "northeurope"
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${var.application}-${var.environment}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "Free"
}

module "vault" {
  source = "../.."

  application = var.application
  environment = var.environment

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
