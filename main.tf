module "labels" {
  source      = "clouddrove/labels/azure"
  version     = "1.0.0"
  name        = var.name
  environment = var.environment
  label_order = var.label_order
  repository  = var.repository
}

resource "azurerm_network_security_group" "nsg" {
  count               = var.enabled ? 1 : 0
  name                = format("nsg-%s", module.labels.id)
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  tags                = module.labels.tags
}

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
}

resource "azurerm_subnet_network_security_group_association" "example" {
  count                     = var.enabled ? length(var.subnet_ids) : 0
  subnet_id                 = element(var.subnet_ids, count.index)
  network_security_group_id = join("", azurerm_network_security_group.nsg.*.id)
}