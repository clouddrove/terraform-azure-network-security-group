output "subnet_ids" {
  value       = module.subnet.default_subnet_id
  description = "The ID of the Subnet. Changing this forces a new resource to be created."
}

output "subnet_name" {
  value       = module.subnet.default_subnet_name
  description = "The name of the subnet. Changing this forces a new resource to be created."
}

output "resource_group_name" {
  description = "The name of the resource group in which the subnet is created in."
  value       = module.resource_group.resource_group_name
}

output "resource_group_location" {
  description = "The name of the resource group in which the subnet is created in."
  value       = module.resource_group.resource_group_location
}

output "virtual_network_name" {
  description = "The name of the virtual network in which the subnet is created in."
  value       = join("", module.vnet.vnet_name)
}

output "address_prefixes" {
  description = "The address prefixes for the subnet."
  value       = module.subnet.default_subnet_address_prefixes
}

output "route_table_id" {
  description = "The Route Table ID."
  value       = module.subnet.route_table_id
}

output "route_table_associated_subnets" {
  description = "The collection of Subnets associated with this route table."
  value       = module.subnet[*].route_table_associated_subnets
}

output "security_group_id" {
  value       = module.network_security_group.id
  description = "Specifies the name of the network security group. Changing this forces a new resource to be created."
}

output "security_group_name" {
  value       = module.network_security_group.name
  description = "The name of the resource group in which to create the network security group. Changing this forces a new resource to be created."
}

output "network_watcher_name" {
  value       = module.network_security_group.network_watcher_name
  description = "The name of the Network Watcher. Changing this forces a new resource to be created."
}

output "storage_account_id" {
  value       = module.network_security_group.storage_account_id
  description = "The ID of the Storage Account where flow logs are stored."
}
