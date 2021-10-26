# Name: outputs.tf
# Owner: Saurav Mitra
# Description: Outputs the Databricks Notebook URL

output "bda_databricks_notebook_url" {
  value       = databricks_notebook.bda_databricks_notebook.url
  description = "The Databricks Notebook URL."
}
