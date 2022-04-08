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
}
