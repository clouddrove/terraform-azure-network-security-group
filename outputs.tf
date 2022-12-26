output "security_group_id" {
  value       = join("", azurerm_network_security_group.default.*.id)
  description = "Specifies the name of the network security group. Changing this forces a new resource to be created."
}

output "security_group_name" {
  value       = join("", azurerm_network_security_group.default.*.name)
  description = "The name of the resource group in which to create the network security group. Changing this forces a new resource to be created."
}

output "outbound_rule_name" {
  value       = join("", azurerm_network_security_rule.outbound.*.name)
  description = "The Name of the Outbound Network Security Rule."
}

output "inbound_custom_rule_name" {
  value       = { for cp in flatten(var.custom_port) : cp.name => cp }
  description = "The Name of the Inbound Network Security Rule."
}

output "tags" {
  value       = module.labels.tags
  description = "The tags associated to resources."
}
