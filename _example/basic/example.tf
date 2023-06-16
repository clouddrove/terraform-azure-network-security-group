##----------------------------------------------------------------------------- 
## Network Security Group module call. 
##-----------------------------------------------------------------------------
module "network_security_group" {
  source                  = "../../"
  name                    = "app"
  environment             = "test"
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  subnet_ids              = module.subnet.default_subnet_id
  inbound_rules = [
    {
      name                  = "ssh"
      priority              = 101
      access                = "Allow"
      protocol              = "Tcp"
      source_address_prefix = "10.20.0.0/32"
      #source_address_prefixes    = ["10.20.0.0/32","10.21.0.0/32"]
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
  enable_diagnostic          = true
  log_analytics_workspace_id = module.log-analytics.workspace_id
}