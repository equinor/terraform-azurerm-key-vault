provider "azurerm" {
  features {}
}

locals {
  postfix = random_id.this.hex

  tags = {
    environment = "test"
  }
}

data "azurerm_client_config" "current" {}

resource "random_id" "this" {
  byte_length = 8
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.postfix}"
  location = var.location
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "log-${local.postfix}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
}

module "vault" {
  source = "../.."

  vault_name                 = "kv-${local.postfix}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id

  access_policies = [
    {
      object_id               = data.azurerm_client_config.current.object_id
      secret_permissions      = ["Get", "List", "Set", "Delete", "Backup", "Restore", "Recover"]
      certificate_permissions = []
      key_permissions         = []
    }
  ]

  firewall_ip_rules = [
    "1.1.1.1/32",
    "2.2.2.2/32",
    "3.3.3.3/32"
  ]

  tags = local.tags
}
