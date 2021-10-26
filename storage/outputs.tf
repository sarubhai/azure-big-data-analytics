# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the Blob Storage Container Name

output "storage_account_name" {
  value       = local.storage_account_name
  description = "The Storage Account Name."
}

output "storage_account_sas_token" {
  value       = data.azurerm_storage_account_sas.bda_storage_acc_sas.sas
  description = "The Storage Account SAS Token."
}

output "blob_dataset_container_name" {
  value       = local.dataset_container_name
  description = "The Blob Storage Name for Generated Datasets."
}

output "blob_resultset_container_name" {
  value       = local.resultset_container_name
  description = "The Blob Storage Name for Resultset Datasets."
}
