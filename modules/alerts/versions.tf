terraform {
  required_version = ">= 1.8.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0" # TODO(@hknutsen): Investigate if this submodule requires a higher minimum version.
    }
  }
}
