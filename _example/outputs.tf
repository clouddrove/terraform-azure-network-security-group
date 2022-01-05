output "security_group_id" {
  value       = module.security_group.security_group_id
  description = "The Name of the Network Security Group."
}

output "security_group_name" {
  value       = module.security_group.security_group_name
  description = "The Name of the Network Security Group."
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
