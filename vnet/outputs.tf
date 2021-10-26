# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the VNET & Subnet IDs
# https://www.terraform.io/docs/configuration/outputs.html

output "virtual_network_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "The Virtual Network Name."
}

output "public_subnet_ids" {
  value       = azurerm_subnet.public_subnet[*].id
  description = "The Public Subnet IDs."
}

output "private_subnet_ids" {
  value       = azurerm_subnet.private_subnet[*].id
  description = "The Private Subnet IDs."
}

output "public_security_group_id" {
  value       = azurerm_network_security_group.public_security_group.id
  description = "The Public Security Group ID."
}

output "private_security_group_id" {
  value       = azurerm_network_security_group.private_security_group.id
  description = "The Private Security Group ID."
}
