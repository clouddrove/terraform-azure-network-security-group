output "id" {
  value       = try(azurerm_network_security_group.nsg[0].id, null)
  description = "The network security group configuration ID."
}

output "name" {
  value       = try(azurerm_network_security_group.nsg[0].name, null)
  description = "The name of the network security group."
}

output "tags" {
  value       = module.labels.tags
  description = "The tags assigned to the resource."
}

output "subnet_id" {
  value       = try(azurerm_subnet_network_security_group_association.nsg_subnet_association[*].subnet_id, null)
  description = "The ID of the Subnet. Changing this forces a new resource to be created."
}

output "network_watcher_name" {
  value       = var.enabled && var.enable_flow_logs ? azurerm_network_watcher_flow_log.nsg_flow_logs[0].name : null
  description = "The name of the Network Watcher. Changing this forces a new resource to be created."
}

output "storage_account_id" {
  value       = var.enabled && var.enable_flow_logs ? azurerm_network_watcher_flow_log.nsg_flow_logs[0].storage_account_id : null
  description = "The ID of the Storage Account where flow logs are stored."
}
