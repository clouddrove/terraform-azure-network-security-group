output "security_group_id" {
  value       = module.network_security_group.id
  description = "Specifies the name of the network security group. Changing this forces a new resource to be created."
}

output "security_group_name" {
  value       = module.network_security_group.name
  description = "The name of the resource group in which to create the network security group. Changing this forces a new resource to be created."
}

