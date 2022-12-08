terraform {
<<<<<<< Updated upstream
  required_version = "~> 1.3"
=======
  required_version = "~> 1.0"
>>>>>>> Stashed changes

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}
