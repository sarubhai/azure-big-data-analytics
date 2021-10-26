# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create the Databricks Resources
# https://www.terraform.io/docs/configuration/variables.html

# Tags
variable "prefix" {
  description = "This prefix will be included in the name of the resources."
}

variable "owner" {
  description = "This owner name tag will be included in the owner of the resources."
}

# Resource Group Location
variable "resource_group_location" {
  description = "Location of Resource Group"
}

variable "resource_group_name" {
  description = "The Resource Group Name."
}

variable "storage_account_name" {
  description = "The Storage Account Name."
}

variable "storage_account_sas_token" {
  description = "The Storage Account SAS Token."
}

variable "blob_dataset_container_name" {
  description = "The Blob Storage Name for Generated Datasets."
}

variable "blob_resultset_container_name" {
  description = "The Blob Storage Name for Resultset Datasets."
}


# Databricks
variable "databricks_spark_version_id" {
  description = "The Databricks Spark Version ID."
}

variable "databricks_node_type_id" {
  description = "The Databricks Node Type ID."
}

variable "databricks_current_user_home" {
  description = "The Databricks Current User Home."
}
