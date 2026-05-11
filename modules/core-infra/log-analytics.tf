// Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.prefix}-law"
  location            = azurerm_resource_group.platform_rg.location
  resource_group_name = azurerm_resource_group.platform_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.5
  tags = local.common_tags

  #internet_ingestion_enabled = true 
  #internet_query_enabled     = true
}