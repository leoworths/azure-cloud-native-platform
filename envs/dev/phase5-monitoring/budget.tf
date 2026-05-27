resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "${var.prefix}-budget"
  resource_group_id = data.azurerm_resource_group.platform.id

  #data.terraform_remote_state.platform.outputs.platform_rg_id

  amount     = var.monthly_budget
  time_grain = "Monthly"

  time_period {
    start_date = "${formatdate("YYYY-MM-01", timestamp())}T00:00:00Z"
    end_date   = "2030-01-01T00:00:00Z"
  }
  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThanOrEqualTo"
    threshold_type = "Actual"

    contact_emails = [var.alert_email]
  }
}