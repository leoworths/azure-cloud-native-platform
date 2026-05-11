# 🔥 Action Group (centralized)
resource "azurerm_monitor_action_group" "alerts" {
  name                = "${local.name_prefix}-alerts"
  resource_group_name = data.terraform_remote_state.platform.outputs.platform_rg_name
  short_name          = "alerts"

  email_receiver {
    name          = "admin"
    email_address = var.alert_email
  }
}

# 🔥 AKS CPU Alert
resource "azurerm_monitor_metric_alert" "cpu" {
  name                = "${local.name_prefix}-cpu"
  resource_group_name = data.terraform_remote_state.platform.outputs.spoke_rg_name
  scopes              = [data.terraform_remote_state.aks.outputs.aks_cluster_id]
  severity            = 2

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.alerts.id
  }
}

# 🔥 Pod Restart Alert (LOG QUERY)
resource "azurerm_monitor_scheduled_query_rules_alert_v2" "pod_restart" {
  name                = "${local.name_prefix}-pod-restart"
  resource_group_name = data.terraform_remote_state.platform.outputs.spoke_rg_name
  location            = data.terraform_remote_state.platform.outputs.spoke_rg_location

  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  severity             = 2

  scopes = [
    data.terraform_remote_state.platform.outputs.log_analytics_workspace_id
  ]

  criteria {
    query = <<QUERY
KubePodInventory
| where ContainerRestartCount > 5
| summarize count()
QUERY

    operator                = "GreaterThan"
    threshold               = 0
    time_aggregation_method = "Count"
  }

  action {
    action_groups = [azurerm_monitor_action_group.alerts.id]
  }
}






