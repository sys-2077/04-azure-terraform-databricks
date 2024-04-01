

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


#--------------------------
#--------------------------

