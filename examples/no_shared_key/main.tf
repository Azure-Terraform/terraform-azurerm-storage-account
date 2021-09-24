provider "azurerm" {
  
  # by default teraform uses the shared access key to access the storage account.
  # to use azure ad auth by default, set this property to true
  storage_use_azuread = true
  
  features {}
}

module "storage_account" {
  source = "../../"

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