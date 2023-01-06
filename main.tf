## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

#Module      : labels
#Description : Terraform module to create consistent naming for multiple names.
module "labels" {
  source      = "clouddrove/labels/azure"
  version     = "1.0.0"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

#Module      : NETWORK SECURITY GROUP
#Description : Terraform resource for security group.
resource "azurerm_network_security_group" "nsg" {
  count               = var.enabled ? 1 : 0
  name                = format("nsg-%s", module.labels.id)
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  tags                = module.labels.tags

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

#Module      : SECURITY GROUP RULE FOR EGRESS
#Description : Provides a security group rule resource. Represents a single egress
#              group rule, which can be added to external Security Groups.
resource "azurerm_network_security_rule" "inbound" {
  for_each                    = { for rule in var.inbound_rules : rule.name => rule }
  resource_group_name         = var.resource_group_name
  network_security_group_name = join("", azurerm_network_security_group.nsg.*.name)
  direction                   = "Inbound"
  name                        = each.value.name
  priority                    = each.value.priority
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = lookup(each.value, "source_address_prefix", "*")
  source_port_range           = lookup(each.value, "source_port_range", "*")
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", "*")
  destination_port_range      = lookup(each.value, "destination_port_range", "*")
  description                 = lookup(each.value, "description", null)

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

resource "azurerm_network_security_rule" "outbound" {
  for_each                    = { for rule in var.outbound_rules : rule.name => rule }
  resource_group_name         = var.resource_group_name
  network_security_group_name = join("", azurerm_network_security_group.nsg.*.name)
  direction                   = "Outbound"
  name                        = each.value.name
  priority                    = each.value.priority
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = lookup(each.value, "source_address_prefix", "*")
  source_port_range           = lookup(each.value, "source_port_range", "*")
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", "*")
  destination_port_range      = lookup(each.value, "destination_port_range", "*")
  description                 = lookup(each.value, "description", null)

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

resource "azurerm_subnet_network_security_group_association" "example" {
  count                     = var.enabled ? length(var.subnet_ids) : 0
  subnet_id                 = element(var.subnet_ids, count.index)
  network_security_group_id = join("", azurerm_network_security_group.nsg.*.id)
}