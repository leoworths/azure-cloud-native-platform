output "app_insights_name" {
  value = azurerm_application_insights.appinsights.name
}

output "action_group_id" {
  value = azurerm_monitor_action_group.alerts.id
}