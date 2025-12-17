terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # Version 4.42.0 is required to use the "rbac_authorization_enabled" argument
      version = ">= 4.42.0"
    }
  }
}
