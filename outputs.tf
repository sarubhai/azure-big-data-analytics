# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the VNET & Subnet IDs
# https://www.terraform.io/docs/configuration/outputs.html

/*
output "resource_group_location" {
  value       = azurerm_resource_group.azure_bda.location
  description = "The Resource Group Location."
}

output "resource_group_name" {
  value       = azurerm_resource_group.azure_bda.name
  description = "The Resource Group Name."
}

output "virtual_network_name" {
  value       = module.vnet.virtual_network_name
  description = "The Virtual Network Name."
}

output "public_subnet_ids" {
  value       = module.vnet.public_subnet_ids
  description = "The Public Subnet IDs."
}

output "private_subnet_ids" {
  value       = module.vnet.private_subnet_ids
  description = "The Private Subnet IDs."
}

output "public_security_group_id" {
  value       = module.vnet.public_security_group_id
  description = "The Public Security Group ID."
}

output "private_security_group_id" {
  value       = module.vnet.private_security_group_id
  description = "The Private Security Group ID."
}
*/


# Databricks
output "bda_databricks_id" {
  value       = azurerm_databricks_workspace.bda_databricks_ws.id
  description = "The ID of the Databricks Workspace in Azure management plane."
}

output "bda_databricks_workspace_id" {
  value       = azurerm_databricks_workspace.bda_databricks_ws.workspace_id
  description = "The ID of the Databricks Workspace in Databricks control plane."
}

output "bda_databricks_workspace_url" {
  value       = azurerm_databricks_workspace.bda_databricks_ws.workspace_url
  description = "The Databricks Workspace URL."
}

output "bda_databricks_notebook_url" {
  value       = module.databricks.bda_databricks_notebook_url
  description = "The Databricks Notebook URL."
}
