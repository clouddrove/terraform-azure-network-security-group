output "security_group_id" {
  value       = module.security_group.security_group_id
  description = "Specifies the name of the network security group. Changing this forces a new resource to be created."
}

output "security_group_name" {
  value       = module.security_group.security_group_name
  description = "The name of the resource group in which to create the network security group. Changing this forces a new resource to be created."
}

output "outbound_rule_name" {
  value       = module.security_group.outbound_rule_name
  description = "The Name of the Outbound Network Security Rule."
}

output "inbound_rule_name" {
  value       = module.security_group.inbound_custom_rule_name
  description = "The Name of the Inbound Network Security Rule."
}

output "tags" {
  value       = module.security_group.tags
  description = "The tags associated to resources."
}
