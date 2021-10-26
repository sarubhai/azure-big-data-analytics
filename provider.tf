# Name: provider.tf
# Owner: Saurav Mitra
# Description: This terraform config will Configure Terraform Providers
# https://www.terraform.io/docs/language/providers/requirements.html

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
    databricks = {
      source  = "databrickslabs/databricks"
      version = "~> 0.3"
    }
  }
}

# Configure Terraform AZURE Provider
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

# $ export ARM_SUBSCRIPTION_ID="SubscriptionId"
# $ export ARM_TENANT_ID="TenantId"
# $ export ARM_CLIENT_ID="ClientId"
# $ export ARM_CLIENT_SECRET="ClientSecret"

provider "azurerm" {
  # Configuration options
  features {}
}


# Configure Terraform Databricks Provider
# https://registry.terraform.io/providers/databrickslabs/databricks/latest/docs

provider "databricks" {
  # Configuration options
  host          = data.azurerm_databricks_workspace.bda_databricks_ws.workspace_url
  azure_use_msi = true
}
