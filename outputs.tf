output "id" {
  value       = join("", azurerm_network_security_group.nsg[*].id)
  description = "The network security group configuration ID."
}

output "name" {
  value       = join("", azurerm_network_security_group.nsg[*].name)
  description = "The name of the network security group."
}

output "tags" {
  value       = module.labels.tags
  description = "The tags assigned to the resource."
}

output "subnet_id" {
  value       = join("", azurerm_subnet_network_security_group_association.example[*].subnet_id)
  description = "The ID of the Subnet. Changing this forces a new resource to be created."
}

output "network_watcher_name" {
  value       = join("", azurerm_network_watcher_flow_log.nsg_flow_logs[*].name)
  description = "The name of the Network Watcher. Changing this forces a new resource to be created."
}

output "storage_account_id" {
  value       = join("", azurerm_network_watcher_flow_log.nsg_flow_logs[*].storage_account_id)
  description = "The ID of the Storage Account where flow logs are stored."
}
