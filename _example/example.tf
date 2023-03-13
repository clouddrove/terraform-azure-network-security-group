# Azure Provider configuration
provider "azurerm" {
  features {}
}

module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.1"
  label_order = ["name", "environment", ]
  name        = "app-name"
  environment = "test"
  location    = "Canada Central"
}

module "vnet" {
  depends_on  = [module.resource_group]
  source      = "clouddrove/vnet/azure"
  version     = "1.0.0"
  label_order = ["name", "environment"]

  name                = "app"
  environment         = "test"
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
      name                   = "rt-app-test"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "10.20.0.4"
    }
  ]

}

module "log-analytics" {
  source                           = "clouddrove/log-analytics/azure"
  version                          = "1.0.0"
  name                             = "app1"
  environment                      = "test1"
  label_order                      = ["name", "environment"]
  create_log_analytics_workspace   = true
  log_analytics_workspace_sku      = "PerGB2018"
  daily_quota_gb                   = "-1"
  internet_ingestion_enabled       = true
  internet_query_enabled           = true
  resource_group_name              = module.resource_group.resource_group_name
  log_analytics_workspace_location = module.resource_group.resource_group_location
}

module "network_security_group" {
  depends_on              = [module.subnet]
  resource_group_location = module.resource_group.resource_group_location
  source                  = "../"
  label_order             = ["name", "environment"]
  name                    = "app1"
  environment             = "test1"
  subnet_ids              = module.subnet.default_subnet_id
  resource_group_name     = module.resource_group.resource_group_name
  inbound_rules = [
    {
      name                       = "ssh"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "67.23.123.234/32"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    },
    {
      name                       = "https"
      priority                   = 102
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
      destination_address_prefix = "0.0.0.0/0"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    }
  ]

  enable_diagnostic          = true
  log_analytics_workspace_id = module.log-analytics.workspace_id
}