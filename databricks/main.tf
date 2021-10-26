# main.tf
# Owner: Saurav Mitra
# Description: This terraform config will create the Databricks Resources

# Databricks Cluster
resource "databricks_cluster" "bda_databricks_cluster" {
  cluster_name            = "bda-databricks-cluster"
  spark_version           = var.databricks_spark_version_id
  node_type_id            = var.databricks_node_type_id
  autotermination_minutes = 10

  # Single-node
  spark_conf = {
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.master" : "local[*]"
  }

  custom_tags = {
    "ResourceClass" = "SingleNode"
  }

  #   autoscale {
  #     min_workers = 1
  #     max_workers = 3
  #   }
}


# Databricks Notebook
resource "databricks_notebook" "bda_databricks_notebook" {
  language = "PYTHON"
  path     = "${var.databricks_current_user_home}/bda_sales_notebook"
  content_base64 = base64encode(<<-EOT
    # created from ${abspath(path.module)}
    blob_account_name = "${var.storage_account_name}"
    blob_sas_token = r"${var.storage_account_sas_token}"

    src_blob_container_name = "${var.blob_dataset_container_name}"
    src_blob_relative_path = "datasets/"
    src_path = 'wasbs://%s@%s.blob.core.windows.net/%s' % (src_blob_container_name, blob_account_name, src_blob_relative_path)
    spark.conf.set('fs.azure.sas.%s.%s.blob.core.windows.net' % (src_blob_container_name, blob_account_name), blob_sas_token)
    # print('Remote blob path: ' + src_path)


    from pyspark.sql.functions import sum as sum
    df_sales = spark.read.csv(src_path + "sales/sales.psv", sep="|", header="true", inferSchema="true")
    df_product = spark.read.csv(src_path + "product/product.psv", sep="|", header="true", inferSchema="true")
    df_product_sales = df_sales.join(df_product, df_sales.product_id == df_product.id, "inner").select(df_product.make.alias("company"), df_sales.quantity, (df_sales.quantity * df_product.price).alias("amount"))
    df_bda_sales = df_product_sales.groupBy("company").agg(sum("amount").alias("sales_amount"), sum("quantity").alias("sales_quantity"))
    # df_bda_sales.show()

    tgt_blob_container_name = "${var.blob_resultset_container_name}"
    tgt_blob_relative_path = "resultsets/"
    tgt_path = 'wasbs://%s@%s.blob.core.windows.net/%s' % (tgt_blob_container_name, blob_account_name, tgt_blob_relative_path)
    spark.conf.set('fs.azure.sas.%s.%s.blob.core.windows.net' % (tgt_blob_container_name, blob_account_name), blob_sas_token)
    # print('Remote blob path: ' + tgt_path)
    
    (df_bda_sales.coalesce(1).write.mode("overwrite").option("header", "true").format("com.databricks.spark.csv").save(tgt_path + "bda_sales"))

    EOT
  )
}


# Databricks Job
resource "databricks_job" "bda_databricks_job" {
  name                = "bda_sales_job"
  existing_cluster_id = databricks_cluster.bda_databricks_cluster.id

  notebook_task {
    notebook_path = databricks_notebook.bda_databricks_notebook.path
  }

  email_notifications {}
}
