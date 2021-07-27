# Configure terraform required version
terraform {
  required_version = ">= 0.13"
  experiments      = [module_variable_optional_attrs]
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.30.0"
    }
  }
}
