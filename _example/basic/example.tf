provider "azurerm" {
  features {}
}
locals {
  name        = "app"
  environment = "test"
}

##-----------------------------------------------------------------------------
## Network Security Group module call.
##-----------------------------------------------------------------------------
module "network_security_group" {
  source                  = "../../"
  name                    = local.name
  environment             = local.environment
  resource_group_name     = "app-storage-test-resource-group"
  resource_group_location = "North Europe"
  subnet_ids              = ["/subscriptions/068245d4-3c94-42fe-9c4d-9e5e1cabc60c/resourceGroups/"]
  inbound_rules = [
    {
      name                       = "ssh"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "10.20.0.0/32"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    },
    {
      name                       = "https"
      priority                   = 102
      access                     = "Allow"
      protocol                   = "*"
      source_address_prefix      = "VirtualNetwork"
      source_port_range          = "80,443"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    }
  ]
  enable_diagnostic = false
}
