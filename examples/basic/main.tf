provider "azurerm" {
  features {}
}

locals {
  tags = {
    environment = "test"
  }
}

data "azurerm_client_config" "current" {}

resource "random_id" "this" {
  byte_length = 8
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${random_id.this.hex}"
  location = var.location

  tags = local.tags
}

module "log_analytics" {
  source = "github.com/equinor/terraform-azurerm-log-analytics?ref=v1.0.0"

  workspace_name      = "log-${random_id.this.hex}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  tags = local.tags
}

module "key_vault" {
  source = "../.."

  vault_name                 = "kv-${random_id.this.hex}"
  resource_group_name        = azurerm_resource_group.this.name
  location                   = azurerm_resource_group.this.location
  log_analytics_workspace_id = module.log_analytics.workspace_id

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
