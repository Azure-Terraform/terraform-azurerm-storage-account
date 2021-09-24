provider "azurerm" {
  
   # 
  storage_use_azuread = true
  
  features {}
}

module "storage_account" {
  source = "../../"

  count = 1

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  account_kind     = "StorageV2"
  replication_type = "LRS"
  account_tier     = "Standard"

  shared_access_key_enabled = false


  service_endpoints = {
    "iaas-outbound" = module.virtual_network.subnet["iaas-outbound"].id
  }
}
