output "id" {
  value       = join("", azurerm_network_security_group.nsg.*.id)
  description = "The network security group configuration ID."
}

output "name" {
  value       = join("", azurerm_network_security_group.nsg.*.name)
  description = "The name of the network security group."
}


# output "outbound_rule_name" {
#   value       = join("", azurerm_network_security_rule.outbound.*.name)
#   description = "The Name of the Outbound Network Security Rule."
# }

# output "inbound_custom_rule_name" {
#   value       = join("", azurerm_network_security_rule.inbound.*.name)
#   description = "The Name of the Inbound Network Security Rule."
# }

output "tags" {
  value       = module.labels.tags
  description = "The tags assigned to the resource."
}
