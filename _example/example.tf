provider "azurerm" {
  features {}
}

module "resource_group" {
  source      = "clouddrove/resource-group/azure"
  version     = "1.0.0"
  environment = "test"
  label_order = ["name", "environment"]

  name     = "example"
  location = "North Europe"
}

module "security_group" {
  source = "../"

  ## Tags
  name        = "example"
  environment = "test"
  label_order = ["name", "environment"]

  ## Security Group
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location

  ##Security Group rule for Custom port.
  custom_port = [{
    name                         = "ssh"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = ["22"]
    source_address_prefixes      = ["67.23.123.234/32"]
    destination_address_prefixes = ["0.0.0.0/0"]
    access                       = "Allow"
    priority                     = 1002
    },
    {
      name                         = "http-https"
      protocol                     = "Tcp"
      source_port_range            = "*"
      destination_port_ranges      = ["80", "443"]
      source_address_prefixes      = ["0.0.0.0/0"]
      destination_address_prefixes = ["0.0.0.0/0"]
      access                       = "Allow"
      priority                     = 1003
    }
  ]
}
