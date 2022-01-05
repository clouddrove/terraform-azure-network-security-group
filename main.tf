## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.

#Module      : labels
#Description : Terraform module to create consistent naming for multiple names.
module "labels" {
  source  = "clouddrove/labels/azure"
  version = "1.0.0"

  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

locals {
  custom_port = var.enabled && length(var.custom_port) > 0 ? { for cp in flatten(var.custom_port) : cp.name => cp } : {}
}

#Module      : SECURITY GROUP
#Description : Terraform resource for security group.
resource "azurerm_network_security_group" "default" {
  count               = var.enabled ? 1 : 0
  name                = format("%s-%s-nsg", var.name, var.environment)
  resource_group_name = var.resource_group_name
  location            = var.location
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
resource "azurerm_network_security_rule" "outbound" {
  count                                      = var.enabled ? 1 : 0
  name                                       = format("%s-outbound-rule", module.labels.id)
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = join("", azurerm_network_security_group.default.*.name)
  description                                = "Outbound traffic."
  protocol                                   = "*"
  source_port_range                          = "*"
  destination_port_range                     = "*"
  source_address_prefix                      = "*"
  source_application_security_group_ids      = var.source_application_security_group_ids
  destination_address_prefix                 = "*"
  destination_application_security_group_ids = var.destination_application_security_group_ids
  access                                     = var.access
  priority                                   = var.priority
  direction                                  = "Outbound"
  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

resource "azurerm_network_security_rule" "inbound_custom" {
  for_each                                   = local.custom_port
  name                                       = format("%s-%s", module.labels.id, each.value.name)
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = join("", azurerm_network_security_group.default.*.name)
  description                                = lookup(each.value, "description", "Inbound traffic")
  protocol                                   = lookup(each.value, "protocol", null)
  source_port_range                          = lookup(each.value, "source_port_range", null)
  destination_port_ranges                    = lookup(each.value, "destination_port_ranges", null)
  source_address_prefixes                    = lookup(each.value, "source_address_prefixes", null)
  source_application_security_group_ids      = lookup(each.value, "source_application_security_group_ids", null)
  destination_address_prefixes               = lookup(each.value, "destination_address_prefixes", null)
  destination_address_prefix                 = lookup(each.value, "destination_address_prefix", null)
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)
  access                                     = lookup(each.value, "access", "Allow")
  priority                                   = lookup(each.value, "priority", null)
  direction                                  = lookup(each.value, "direction", "Inbound")
  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}
