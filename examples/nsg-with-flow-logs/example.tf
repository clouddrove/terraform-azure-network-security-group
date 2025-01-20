provider "azurerm" {
  features {}
  subscription_id = "000000-11111-1223-XXX-XXXXXXXXXXXX"

}
provider "azurerm" {
  features {}
  alias = "peer"
  subscription_id = "000000-11111-1223-XXX-XXXXXXXXXXXX"
}

locals {
  name        = "app"
  environment = "test"
  label_order = ["name", "environment"]
}

##-----------------------------------------------------------------------------
## Resource Group module call
## Resource group in which all resources will be deployed.
##-----------------------------------------------------------------------------
module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.2"
  name        = local.name
  environment = local.environment
  label_order = local.label_order
  location    = "West Europe"
}

##-----------------------------------------------------------------------------
## Virtual Network module call.
##-----------------------------------------------------------------------------
module "vnet" {
  depends_on             = [module.resource_group]
  source                 = "clouddrove/vnet/azure"
  version                = "1.0.4"
  name                   = local.name
  environment            = local.environment
  resource_group_name    = module.resource_group.resource_group_name
  location               = module.resource_group.resource_group_location
  address_spaces         = ["10.30.0.0/22"]
  enable_network_watcher = true
}

##-----------------------------------------------------------------------------
## Subnet Module call.
## Subnet to which network security group will be attached.
##-----------------------------------------------------------------------------
module "subnet" {
  source               = "clouddrove/subnet/azure"
  version              = "1.2.1"
  name                 = local.name
  environment          = local.environment
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  virtual_network_name = module.vnet.vnet_name
  # Subnet Configuration
  subnet_names    = ["subnet"]
  subnet_prefixes = ["10.30.0.0/24"]
  # routes
  enable_route_table = true
  route_table_name   = "default_subnet"
  # routes
  routes = [
    {
      name           = "rt-test"
      address_prefix = "0.0.0.0/0"
      next_hop_type  = "Internet"
    }
  ]
}

##-----------------------------------------------------------------------------
## Storage Module call.
## Storage account in which network security group flow log will be received.
##-----------------------------------------------------------------------------
module "storage" {
  source  = "clouddrove/storage/azure"
  version = "1.1.1"
  providers = {
    azurerm.dns_sub  = azurerm.peer, #change this to other alias if dns hosted in other subscription.
    azurerm.main_sub = azurerm
  }
  name                 = local.name
  environment          = local.environment
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  storage_account_name = "mystorage42412487"
  ##   Storage Container
  containers_list = [
    { name = "app-test", access_type = "private" },
    { name = "app2", access_type = "private" },
  ]
  ##   Storage File Share
  file_shares = [
    { name = "fileshare1", quota = 5 },
  ]
  ##   Storage Tables
  tables = ["table1"]
  ## Storage Queues
  queues                   = ["queue1"]
  management_policy_enable = true
  #enable private endpoint
  virtual_network_id = module.vnet.vnet_id
  subnet_id          = module.subnet.default_subnet_id[0]
  enable_diagnostic  = false
}

##-----------------------------------------------------------------------------
## Network Security Group module call.
##-----------------------------------------------------------------------------
module "network_security_group" {
  depends_on                        = [module.subnet, module.storage]
  source                            = "../../"
  name                              = local.name
  environment                       = local.environment
  resource_group_name               = module.resource_group.resource_group_name
  resource_group_location           = module.resource_group.resource_group_location
  subnet_ids                        = module.subnet.default_subnet_id
  enable_flow_logs                  = true
  network_watcher_name              = module.vnet.network_watcher_name
  flow_log_storage_account_id       = module.storage.storage_account_id
  enable_traffic_analytics          = false
  flow_log_retention_policy_enabled = true
  enable_diagnostic                 = true
  subnet_association                = true
  inbound_rules = [
    {
      name                       = "ssh"
      priority                   = 101
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "10.20.0.0/32"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "22"
      description                = "ssh allowed port"
    },
    {
      name                       = "https"
      priority                   = 102
      access                     = "Allow"
      protocol                   = "Tcp"
      source_address_prefix      = "0.0.0.0/0"
      source_port_range          = "*"
      destination_address_prefix = "VirtualNetwork"
      destination_port_range     = "80,443"
      description                = "https allowed port"
    }
  ]
  logs = [{
    category = "NetworkSecurityGroupEvent"
    },
    {
      category = "NetworkSecurityGroupRuleCounter"
    }
  ]
}
