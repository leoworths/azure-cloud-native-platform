output "platform_mg_id" {
  value = azurerm_management_group.platform.id
}
output "workloads_mg_id" {
  value = azurerm_management_group.workloads.id
}
output "dev_mg_id" {
  value = azurerm_management_group.dev.id
}
output "staging_mg_id" {
  value = azurerm_management_group.staging.id
}
output "prod_mg_id" {
  value = azurerm_management_group.prod.id
}
output "platform_admins_object_id" {
  value = azuread_group.platform_admins.object_id
}
output "platform_operators_object_id" {
  value = azuread_group.platform_operators.object_id
}
output "platform_developers_object_id" {
  value = azuread_group.platform_developers.object_id
}
output "platform_readers_object_id" {
  value = azuread_group.platform_readers.object_id
}


