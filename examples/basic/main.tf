provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

resource "random_id" "this" {
  byte_length = 8
}

module "log_analytics" {
  source = "github.com/equinor/terraform-azurerm-log-analytics?ref=v1.5.0"

  workspace_name      = "log-${random_id.this.hex}"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_monitor_action_group" "this" {
  name                = "ag-${random_id.this.hex}"
  resource_group_name = var.resource_group_name
  short_name          = "Action"
}

module "key_vault" {
  # source = "github.com/equinor/terraform-azurerm-key-vault"
  source = "../.."

  vault_name                 = "kv-${random_id.this.hex}"
  resource_group_name        = var.resource_group_name
  location                   = var.location
  log_analytics_workspace_id = module.log_analytics.workspace_id
  action_group_id            = azurerm_monitor_action_group.this.id
}

# Give current client full access to Key Vault secrets

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "example" {
  scope                = module.key_vault.vault_id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
