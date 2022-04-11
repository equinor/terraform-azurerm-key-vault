provider "azurerm" {
  features {}
}

locals {
  application = random_id.this.hex
  environment = "test"
}

resource "random_id" "this" {
  byte_length = 8
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.application}-${local.environment}"
  location = var.location
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

  client_secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]

  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
}

resource "random_password" "this" {
  length = 16
}

resource "azurerm_key_vault_secret" "this" {
  name         = "password"
  value        = random_password.this.result
  key_vault_id = module.vault.key_vault_id
}
