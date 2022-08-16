provider "azurerm" {
  features {}
}

locals {
  application = random_id.this.hex
  environment = "test"
}

data "azurerm_client_config" "current" {}

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

  application                = local.application
  environment                = local.environment
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  firewall_ip_rules          = var.firewall_ip_rules
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  access_policies = [
    {
      object_id               = data.azurerm_client_config.current.object_id
      secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore", "Recover"]
      certificate_permissions = []
      key_permissions         = []
    }
  ]
}
