terraform {

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.7"
    }
    random = {
      source= "hashicorp/random"
      version = ">= 3.1"
    }
  }
}