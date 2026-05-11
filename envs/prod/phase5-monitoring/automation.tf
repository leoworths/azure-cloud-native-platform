resource "azurerm_automation_account" "automation" {
  name                = "${local.name_prefix}-automation"
  location            = data.terraform_remote_state.platform.outputs.platform_rg_location
  resource_group_name = data.terraform_remote_state.platform.outputs.platform_rg_name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

# ✅ ROLE ASSIGNMENT FOR AUTOMATION ACCOUNT TO ACCESS AKS
resource "azurerm_role_assignment" "aks" {
  scope                = data.terraform_remote_state.aks.outputs.aks_cluster_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_automation_account.automation.identity[0].principal_id
}

# ✅ RUNBOOKS (CLEAN)
resource "azurerm_automation_runbook" "scale_down" {
  name                    = "${local.name_prefix}-scale-down"
  location                = data.terraform_remote_state.platform.outputs.platform_rg_location
  resource_group_name     = data.terraform_remote_state.platform.outputs.platform_rg_name
  automation_account_name = azurerm_automation_account.automation.name
  runbook_type            = "PowerShell"
  log_verbose             = true
  log_progress            = true

  description = "Scale AKS node pool down (cost optimization)"

  content = file("${path.module}/runbooks/scale-down.ps1")
}

resource "azurerm_automation_runbook" "scale_up" {
  name                    = "${local.name_prefix}-scale-up"
  location                = data.terraform_remote_state.platform.outputs.platform_rg_location
  resource_group_name     = data.terraform_remote_state.platform.outputs.platform_rg_name
  automation_account_name = azurerm_automation_account.automation.name
  runbook_type            = "PowerShell"
  log_verbose             = true
  log_progress            = true

  description = "Scale AKS node pool up (business hours)"

  content = file("${path.module}/runbooks/scale-up.ps1")
}

# ✅ SCHEDULE DOWN
resource "azurerm_automation_schedule" "scale_down" {
  name                    = "${local.name_prefix}-scale-down"
  resource_group_name     = data.terraform_remote_state.platform.outputs.platform_rg_name
  automation_account_name = azurerm_automation_account.automation.name

  frequency  = "Week"
  interval   = 1
  timezone   = "UTC"
  start_time = timeadd(timestamp(), "15m")

  week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

# ✅ SCHEDULE UP
resource "azurerm_automation_schedule" "scale_up" {
  name                    = "${local.name_prefix}-scale-up"
  resource_group_name     = data.terraform_remote_state.platform.outputs.platform_rg_name
  automation_account_name = azurerm_automation_account.automation.name

  frequency  = "Week"
  interval   = 1
  timezone   = "UTC"
  start_time = timeadd(timestamp(), "15m")

  week_days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

# ✅ LINK RUNBOOKS
resource "azurerm_automation_job_schedule" "scale_down" {
  resource_group_name     = data.terraform_remote_state.platform.outputs.platform_rg_name
  automation_account_name = azurerm_automation_account.automation.name
  schedule_name           = azurerm_automation_schedule.scale_down.name
  runbook_name            = azurerm_automation_runbook.scale_down.name
}

resource "azurerm_automation_job_schedule" "scale_up" {
  resource_group_name     = data.terraform_remote_state.platform.outputs.platform_rg_name
  automation_account_name = azurerm_automation_account.automation.name
  schedule_name           = azurerm_automation_schedule.scale_up.name
  runbook_name            = azurerm_automation_runbook.scale_up.name
}