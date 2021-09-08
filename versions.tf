# Configure terraform required version
terraform {
  experiments      = [module_variable_optional_attrs]
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.72"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}
