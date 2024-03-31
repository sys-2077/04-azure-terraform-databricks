

#--------------------------
# Azure Databricks Service Principal
#--------------------------

# >> reate a service principal for Azure Databricks
resource "azuread_application" "this" {
  display_name = "Terraform Databricks Service Principal"
}
# >> Create a service principal password for Azure Databricks
resource "azuread_service_principal" "this" {
  application_id = azuread_application.this.application_id
}
# >> Rotate the service principal password every month
resource "time_rotating" "month" {
  rotation_days = 30
}
# >> Create a service principal password for Azure Databricks
resource "azuread_service_principal_password" "this" {
  service_principal_id = azuread_service_principal.this.object_id
  rotate_when_changed  = { rotation = time_rotating.month.id }
}
# >> Subscription core role assignment
data "azurerm_subscription" "core" {}
# >> Assign the service principal to the subscription owner role
resource "azurerm_role_assignment" "core" {
  scope = data.azurerm_subscription.core.id
  role_definition_name = "Owner"
  principal_id = azuread_service_principal.this.object_id
}

#--------------------------
#--------------------------


#--------------------------
# Resource Group
#--------------------------

# >> Create a resource group
resource "azurerm_resource_group" "this" {
  name     = "dbtr-rg"
  location = var.location

  tags = {
    environment = var.env
  }
}


#--------------------------
#--------------------------


#--------------------------
# Databricks Workspace
#--------------------------

# >> Create a Databricks workspace
resource "azurerm_databricks_workspace" "this" {
  name                        = "db-workspace"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  sku                         = "standard"
  managed_resource_group_name = "db-workspace-rg"

  tags = {
    environment = var.env
  }
}

# >> Create Cluster in Databricks workspace
resource "databricks_cluster" "this" {
  cluster_name            = "democluster"
  num_workers             = var.workers
  node_type_id            = var.node_type
  spark_version           = "7.3.x-scala2.12"
  
  spark_conf = {
    "spark.databricks.cluster.profile" : "singleNode"
    "spark.databricks.unity.catalog.enabled" : "true"
  }

  custom_tags = {
    environment = var.env
  }
}
#--------------------------
#--------------------------

