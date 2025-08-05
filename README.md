
module "storage_account" {
  source  = "Azure/storage-account/azurerm"
  version = "3.8.0" # update if necessary

  name                      = "mystorageacct2025"
  resource_group_name       = "my-resource-group"
  location                  = "eastus"
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  enable_https_traffic_only = true

  tags = {
    environment = "dev"
    purpose     = "mystorage-group"
  }
}
