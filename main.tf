##-----------------------------------------------------------------------------
## Managed By : CloudDrove
## Copyright @ CloudDrove. All Right Reserved.
##-----------------------------------------------------------------------------

##-----------------------------------------------------------------------------
## Module      : labels
## Description : Terraform module to create consistent naming for multiple names.
##-----------------------------------------------------------------------------
module "labels" {
  source      = "clouddrove/labels/azure"
  version     = "1.0.0"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
  repository  = var.repository
}

##-----------------------------------------------------------------------------
## Below resource will create network security group in azure. 
##-----------------------------------------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  count               = var.enabled ? 1 : 0
  name                = format("%s-nsg", module.labels.id)
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

##-----------------------------------------------------------------------------
## Below resource will create network security group inbound rules in azure and will be attached to above network security group.  
##-----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "inbound" {
  for_each                     = { for rule in var.inbound_rules : rule.name => rule }
  resource_group_name          = var.resource_group_name
  network_security_group_name  = join("", azurerm_network_security_group.nsg.*.name)
  direction                    = "Inbound"
  name                         = each.value.name
  priority                     = each.value.priority
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_address_prefix        = lookup(each.value, "source_address_prefix", null)   // To be passed when only one source address or all address has to be passed or tag has to be passed
  source_address_prefixes      = lookup(each.value, "source_address_prefixes", null) // to be passed when 2 or more but not all address has to be passed
  source_port_range            = lookup(each.value, "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges           = lookup(each.value, "source_port_range", "*") == "*" ? null : split(",", each.value.source_port_range)
  destination_address_prefix   = lookup(each.value, "destination_address_prefix", "*")    // To be passed when only one source address or all address has to be passed or tag has to be passed
  destination_address_prefixes = lookup(each.value, "destination_address_prefixes", null) // to be passed when 2 or more but not all address has to be passed
  destination_port_range       = lookup(each.value, "destination_port_range", null) == "*" ? "*" : null
  destination_port_ranges      = lookup(each.value, "destination_port_range", "*") == "*" ? null : split(",", each.value.destination_port_range)
  description                  = lookup(each.value, "description", null)

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

##-----------------------------------------------------------------------------
## Below resource will create network security group outbound rules in azure and will be attached to above network security group.  
##-----------------------------------------------------------------------------
resource "azurerm_network_security_rule" "outbound" {
  for_each                     = { for rule in var.outbound_rules : rule.name => rule }
  resource_group_name          = var.resource_group_name
  network_security_group_name  = join("", azurerm_network_security_group.nsg.*.name)
  direction                    = "Outbound"
  name                         = each.value.name
  priority                     = each.value.priority
  access                       = each.value.access
  protocol                     = each.value.protocol
  source_address_prefix        = lookup(each.value, "source_address_prefix", null)   // To be passed when only one source address or all address has to be passed or tag has to be passed
  source_address_prefixes      = lookup(each.value, "source_address_prefixes", null) // to be passed when 2 or more but not all address has to be passed
  source_port_range            = lookup(each.value, "source_port_range", "*") == "*" ? "*" : null
  source_port_ranges           = lookup(each.value, "source_port_range", "*") == "*" ? null : split(",", each.value.source_port_range)
  destination_address_prefix   = lookup(each.value, "destination_address_prefix", "*")    // To be passed when only one source address or all address has to be passed or tag has to be passed
  destination_address_prefixes = lookup(each.value, "destination_address_prefixes", null) // to be passed when 2 or more but not all address has to be passed
  destination_port_range       = lookup(each.value, "destination_port_range", null) == "*" ? "*" : null
  destination_port_ranges      = lookup(each.value, "destination_port_range", "*") == "*" ? null : split(",", each.value.destination_port_range)
  description                  = lookup(each.value, "description", null)

  timeouts {
    create = var.create
    update = var.update
    read   = var.read
    delete = var.delete
  }
}

##-----------------------------------------------------------------------------
## Below resource will associate above created network security group to subnet. 
##-----------------------------------------------------------------------------
resource "azurerm_subnet_network_security_group_association" "example" {
  count                     = var.enabled ? length(var.subnet_ids) : 0
  subnet_id                 = element(var.subnet_ids, count.index)
  network_security_group_id = join("", azurerm_network_security_group.nsg.*.id)
}

##-----------------------------------------------------------------------------
## Below resource will create network watcher flow logs for network security group. 
## Network security groups flow logging is a feature of Azure Network Watcher that allows you to log information about IP traffic flowing through a network security group.
##-----------------------------------------------------------------------------
resource "azurerm_network_watcher_flow_log" "nsg_flow_logs" {
  count                     = var.enabled && var.enable_flow_logs ? 1 : 0
  enabled                   = true
  version                   = var.flow_log_version
  network_watcher_name      = var.network_watcher_name
  resource_group_name       = var.resource_group_name
  name                      = format("%s-flow_logs", module.labels.id)
  network_security_group_id = join("", azurerm_network_security_group.nsg.*.id)
  storage_account_id        = var.flow_log_storage_account_id
  retention_policy {
    enabled = var.flow_log_retention_policy_enabled
    days    = var.flow_log_retention_policy_days
  }
  dynamic "traffic_analytics" {
    for_each = var.enable_traffic_analytics ? [1] : []
    content {
      enabled               = var.enable_traffic_analytics
      workspace_id          = var.log_analytics_workspace_id
      workspace_region      = var.resource_group_location
      workspace_resource_id = var.log_analytics_workspace_resource_id
      interval_in_minutes   = 60
    }
  }
}

##----------------------------------------------------------------------------- 
## Below resource will create diagnostic setting for network security group.  
##-----------------------------------------------------------------------------
resource "azurerm_monitor_diagnostic_setting" "example" {
  count                          = var.enabled && var.enable_diagnostic ? 1 : 0
  name                           = format("%s-nsg-diagnostic-log", module.labels.id)
  target_resource_id             = azurerm_network_security_group.nsg[0].id
  storage_account_id             = var.storage_account_id
  eventhub_name                  = var.eventhub_name
  eventhub_authorization_rule_id = var.eventhub_authorization_rule_id
  log_analytics_workspace_id     = var.log_analytics_workspace_id
  log_analytics_destination_type = var.log_analytics_destination_type

  enabled_log {

    category_group = "AllLogs"
    retention_policy {
      enabled = var.retention_policy_enabled
      days    = var.days
    }
    category = var.category
  }

  lifecycle {
    ignore_changes = [log_analytics_destination_type]
  }
}
