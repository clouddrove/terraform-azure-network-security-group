output "id" {
  value       = join("", azurerm_network_security_group.nsg.*.id)
  description = "The network security group configuration ID."
}

output "name" {
  value       = join("", azurerm_network_security_group.nsg.*.name)
  description = "The name of the network security group."
}

output "tags" {
  value       = module.labels.tags
  description = "The tags assigned to the resource."
}
