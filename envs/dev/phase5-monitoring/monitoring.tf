# 🔥 AKS Diagnostic Logs (COST OPTIMIZED)
resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "${local.name_prefix}-aks-logs"
  target_resource_id         = data.terraform_remote_state.aks.outputs.aks_cluster_id
  log_analytics_workspace_id = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id

  # ✅ KEEP ONLY HIGH VALUE LOGS
  enabled_log { category = "kube-audit" }
  enabled_log { category = "kube-apiserver" }

  enabled_metric {
    category = "AllMetrics"
  }
}

# 🔥 Key Vault Diagnostics
resource "azurerm_monitor_diagnostic_setting" "kv" {
  name                       = "${local.name_prefix}-kv-logs"
  target_resource_id         = data.terraform_remote_state.platform.outputs.keyvault_id
  log_analytics_workspace_id = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id

  enabled_log { category = "AuditEvent" }

  enabled_metric {
    category = "AllMetrics"
  }
}

# 🔥 Application Insights
resource "azurerm_application_insights" "appinsights" {
  name                = "${local.name_prefix}-appi"
  location            = data.terraform_remote_state.platform.outputs.spoke_rg_location
  resource_group_name = data.terraform_remote_state.platform.outputs.spoke_rg_name
  application_type    = "web"

  workspace_id = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id
}