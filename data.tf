data "azurerm_virtual_network" "vnet" {
  name                = var.private_link.vnet_name
  resource_group_name = var.resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = var.private_link.subnet_name
  virtual_network_name = var.private_link.vnet_name
  resource_group_name  = var.resource_group_name
}