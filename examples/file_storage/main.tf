provider "azurerm" {
  features {}
  storage_use_azuread = true
}

data "http" "my_ip" {
  url = "https://ifconfig.me"
}

data "azurerm_subscription" "current" {
}

resource "random_string" "random" {
  length  = 12
  upper   = false
  special = false
}

module "subscription" {
  source          = "github.com/Azure-Terraform/terraform-azurerm-subscription-data.git?ref=v1.0.0"
  subscription_id = data.azurerm_subscription.current.subscription_id
}

module "naming" {
  source = "git@github.com:Azure-Terraform/example-naming-template.git?ref=v1.0.0"
}

module "metadata" {
  source = "github.com/Azure-Terraform/terraform-azurerm-metadata.git?ref=v1.1.0"

  naming_rules = module.naming.yaml

  market              = "us"
  project             = "https://github.com/Azure-Terraform/terraform-azurerm-storage-account/tree/main/example"
  location            = "eastus2"
  environment         = "sandbox"
  product_name        = random_string.random.result
  business_unit       = "infra"
  product_group       = "contoso"
  subscription_id     = module.subscription.output.subscription_id
  subscription_type   = "dev"
  resource_group_type = "app"
}

module "resource_group" {
  source = "github.com/Azure-Terraform/terraform-azurerm-resource-group.git?ref=v1.0.0"

  location = module.metadata.location
  names    = module.metadata.names
  tags     = module.metadata.tags
}

module "virtual_network" {
  source = "github.com/Azure-Terraform/terraform-azurerm-virtual-network.git?ref=v2.6.0"

  naming_rules = module.naming.yaml

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  names               = module.metadata.names
  tags                = module.metadata.tags

  address_space = ["10.1.1.0/24"]

  subnets = {
    iaas-outbound = {
      cidrs             = ["10.1.1.0/27"]
      service_endpoints = ["Microsoft.Storage"]
    }
  }
}

module "storage_account" {
  source = "../../"

  resource_group_name = module.resource_group.name
  location            = module.resource_group.location

  tags = module.metadata.tags

  account_kind              = "FileStorage"
  replication_type          = "LRS"
  account_tier              = "Premium"
  access_tier               = "Hot"
  enable_large_file_share   = true
  shared_access_key_enabled = false

  access_list = {
    "my_ip" = data.http.my_ip.body
  }

  service_endpoints = {
    "iaas-outbound" = module.virtual_network.subnet["iaas-outbound"].id
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "arb" {
  scope                = module.storage_account.id
  role_definition_name = "Owner"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [module.storage_account]
}

resource "azurerm_storage_share" "example" {
  count = 0

  name                 = "sharename"
  storage_account_name = module.storage_account.name
  quota                = 50

  acl {
    id = "MTIzNDU2Nzg5MDEyMzQ1Njc4OTAxMjM0NTY3ODkwMTI"

    access_policy {
      permissions = "rwdl"
      start       = "2019-07-02T09:38:21.0000000Z"
      expiry      = "2019-07-02T10:38:21.0000000Z"
    }
  }
}
