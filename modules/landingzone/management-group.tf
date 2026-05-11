
// Management Groups (landing zone Hierarchy)
resource "azurerm_management_group" "platform" {
  name         = "mg-platform"
  display_name = "Platform"
}

resource "azurerm_management_group" "workloads" {
  name                       = "mg-workloads"
  display_name               = "Workloads"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "dev" {
  name                       = "mg-dev"
  display_name               = "Dev"
  parent_management_group_id = azurerm_management_group.workloads.id
}
resource "azurerm_management_group" "staging" {
  name                       = "mg-staging"
  display_name               = "Staging"
  parent_management_group_id = azurerm_management_group.workloads.id
}
resource "azurerm_management_group" "prod" {
  name                       = "mg-prod"
  display_name               = "Prod"
  parent_management_group_id = azurerm_management_group.workloads.id
}