# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create the Blob Storage Container
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

# Storage Account SAS
variable "sas_start" {
  description = "SAS Start Datetime"
}

variable "sas_expiry" {
  description = "SAS End Datetime"
}
