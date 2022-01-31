terraform {
  experiments = [module_variable_optional_attrs]

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.94.0, < 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}
