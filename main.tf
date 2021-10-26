# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the infrastructure resources for Azure Big Data Analytics

# Resource Group
resource "azurerm_resource_group" "azure_bda" {
  name     = "${var.prefix}-rg"
  location = var.rg_location
}

# VNet & Subnets
module "vnet" {
  source                  = "./vnet"
  prefix                  = var.prefix
  owner                   = var.owner
  resource_group_location = azurerm_resource_group.azure_bda.location
  resource_group_name     = azurerm_resource_group.azure_bda.name
  vnet_cidr_block         = var.vnet_cidr_block
  private_subnets         = var.private_subnets
  public_subnets          = var.public_subnets
}

# Storage
module "storage" {
  source                  = "./storage"
  prefix                  = var.prefix
  owner                   = var.owner
  resource_group_location = azurerm_resource_group.azure_bda.location
  resource_group_name     = azurerm_resource_group.azure_bda.name
  sas_start               = var.sas_start
  sas_expiry              = var.sas_expiry
}


# Azure Databricks Workspace
resource "azurerm_databricks_workspace" "bda_databricks_ws" {
  name                              = "bda-databricks-ws"
  location                          = azurerm_resource_group.azure_bda.location
  resource_group_name               = azurerm_resource_group.azure_bda.name
  sku                               = "trial"
  public_network_access_enabled     = true
  infrastructure_encryption_enabled = false

  tags = {
    Name    = "bda-databricks-ws"
    Owner   = var.owner
    Project = var.prefix
  }
}


# Databricks Resources

data "azurerm_databricks_workspace" "bda_databricks_ws" {
  name                = azurerm_databricks_workspace.bda_databricks_ws.name
  resource_group_name = azurerm_resource_group.azure_bda.name
}

data "databricks_current_user" "me" {
  depends_on = [azurerm_databricks_workspace.bda_databricks_ws]
}

data "databricks_node_type" "smallest" {
  local_disk = true
  depends_on = [azurerm_databricks_workspace.bda_databricks_ws]
}

data "databricks_spark_version" "latest_lts" {
  long_term_support = true
  depends_on        = [azurerm_databricks_workspace.bda_databricks_ws]
}


module "databricks" {
  source = "./databricks"

  providers = {
    databricks = databricks
  }

  prefix                        = var.prefix
  owner                         = var.owner
  resource_group_location       = azurerm_resource_group.azure_bda.location
  resource_group_name           = azurerm_resource_group.azure_bda.name
  storage_account_name          = module.storage.storage_account_name
  storage_account_sas_token     = module.storage.storage_account_sas_token
  blob_dataset_container_name   = module.storage.blob_dataset_container_name
  blob_resultset_container_name = module.storage.blob_resultset_container_name
  databricks_spark_version_id   = data.databricks_spark_version.latest_lts.id
  databricks_node_type_id       = data.databricks_node_type.smallest.id
  databricks_current_user_home  = data.databricks_current_user.me.home
}
