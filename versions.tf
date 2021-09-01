terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.72"
      storage_use_azuread = true
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}
