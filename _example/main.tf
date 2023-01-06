# Azure Provider configuration
provider "azurerm" {
  features {}
}

module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.1"
  label_order = ["name", "environment", ]
  name        = "ota"
  environment = "staging"
  location    = "Canada Central"
}

module "vnet" {
  depends_on  = [module.resource_group]
  source      = "clouddrove/vnet/azure"
  version     = "1.0.0"
  label_order = ["name", "environment"]

  name                = "ota"
  environment         = "staging"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  address_space       = "10.30.0.0/22"
  enable_ddos_pp      = false
}

module "subnet" {
  source  = "clouddrove/subnet/azure"
  version = "1.0.0"

  name                 = "example-subnet"
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = join("", module.vnet.vnet_name)

  # Subnet Configuration
  subnet_prefixes               = ["10.30.0.0/24"]
  disable_bgp_route_propagation = false

  # routes
  enable_route_table = true

  routes = [
    {
      name                   = "rt-ota-staging"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.20.0.4"
    }
  ]

}

module "network_security_group" {
  depends_on              = [module.subnet]
  resource_group_location = module.resource_group.resource_group_location
  source                  = "../"
  label_order             = ["name", "environment"]
  app_name                = "ota"
  environment             = "staging"
  subnet_ids              = module.subnet.default_subnet_id
  resource_group_name     = module.resource_group.resource_group_name
}