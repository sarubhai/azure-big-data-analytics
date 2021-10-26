# variables.tf
# Owner: Saurav Mitra
# Description: Variables used by terraform config to create a VNet & Subnets
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

# VNET CIDR
variable "vnet_cidr_block" {
  description = "The address space that is used by the virtual network."
}

# Subnet CIDR
variable "private_subnets" {
  description = "A list of CIDR blocks to use for the private subnet."
}

variable "public_subnets" {
  description = "A list of CIDR blocks to use for the public subnet."
}
