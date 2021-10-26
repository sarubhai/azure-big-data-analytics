# Azure Resources deployment to explore Big Data Analytics

Deploys various Azure resources using Terraform to get started with Big Data Analytics.

## Resources

The following Azure resources will be deployed by Terraform:

- 1 Resource Group
- 1 VNET
- 2 Subnet
- 1 Network Security Group
- 1 NAT Gateway
- 1 Storage Account
- 2 Storage Container
- 5 Storage Blob file uploads
- 1 Storage Account SAS
- 1 Azure Databricks Workspace

The following Databricks resources will be deployed by Terraform:

- 1 Databricks Cluster
- 1 Databricks Notebook
- 1 Databricks Job

### Prerequisite

Terraform is already installed in local machine.

## Usage

- Clone this repository
- Generate & setup GCP & Snowflake Access Credentials
- Add the below Terraform variable values

### terraform.tfvars

- Add the below variable values as Environment Variables

```
export ARM_SUBSCRIPTION_ID='SubscriptionId'

export ARM_TENANT_ID='TenantId'

export ARM_CLIENT_ID='ClientId'

export ARM_CLIENT_SECRET='ClientSecret'
```

- Change other variables in variables.tf file if needed
- terraform init
- terraform plan
- terraform apply -auto-approve
- Finally browse the Azure Console and explore the other services.

### Destroy Resources

- terraform destroy -auto-approve
