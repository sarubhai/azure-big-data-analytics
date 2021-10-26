# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Blob Storage Container

resource "random_integer" "rid" {
  min = 100
  max = 900
}

locals {
  suffix                   = random_integer.rid.result
  storage_account_name     = "bigdatastorageacc${local.suffix}"
  dataset_container_name   = "bigdatadataset${local.suffix}"
  resultset_container_name = "bigdataresultset${local.suffix}"
}

resource "azurerm_storage_account" "bda_storage_acc" {
  name                     = local.storage_account_name
  location                 = var.resource_group_location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    Name    = local.storage_account_name
    Owner   = var.owner
    Project = var.prefix
  }
}

resource "azurerm_storage_container" "dataset_container" {
  name                  = local.dataset_container_name
  storage_account_name  = azurerm_storage_account.bda_storage_acc.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "resultset_container" {
  name                  = local.resultset_container_name
  storage_account_name  = azurerm_storage_account.bda_storage_acc.name
  container_access_type = "private"
}

# Upload Sample Dataset Files
resource "azurerm_storage_blob" "dataset_files" {
  for_each               = fileset(path.module, "**/*.psv")
  name                   = each.value
  storage_account_name   = azurerm_storage_account.bda_storage_acc.name
  storage_container_name = azurerm_storage_container.dataset_container.name
  type                   = "Block"
  source                 = "${path.module}/${each.value}"
}

# Upload Hive Script Files
resource "azurerm_storage_blob" "hive_script_files" {
  for_each               = fileset(path.module, "scripts/*.hql")
  name                   = each.value
  storage_account_name   = azurerm_storage_account.bda_storage_acc.name
  storage_container_name = azurerm_storage_container.dataset_container.name
  type                   = "Block"
  source                 = "${path.module}/${each.value}"
}

# Upload Pig Script Files
resource "azurerm_storage_blob" "pig_script_files" {
  for_each               = fileset(path.module, "scripts/*.pig")
  name                   = each.value
  storage_account_name   = azurerm_storage_account.bda_storage_acc.name
  storage_container_name = azurerm_storage_container.dataset_container.name
  type                   = "Block"
  source                 = "${path.module}/${each.value}"
}

# Upload Python Spark Files
resource "azurerm_storage_blob" "spark_script_files" {
  for_each               = fileset(path.module, "scripts/*.py")
  name                   = each.value
  storage_account_name   = azurerm_storage_account.bda_storage_acc.name
  storage_container_name = azurerm_storage_container.dataset_container.name
  type                   = "Block"
  source                 = "${path.module}/${each.value}"
}

# Shared Access Signature Token for the Storage Account
data "azurerm_storage_account_sas" "bda_storage_acc_sas" {
  connection_string = azurerm_storage_account.bda_storage_acc.primary_connection_string
  signed_version    = "2017-07-29"

  services {
    blob  = true
    file  = false
    queue = false
    table = false
  }

  resource_types {
    service   = true
    container = true
    object    = true
  }

  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
  }

  start      = var.sas_start
  expiry     = var.sas_expiry
  https_only = true
}
