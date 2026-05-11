// Subscription
# resource "azurerm_subscription" "platform_prod" {
#     subscription_name = "Platform-Prod"
#     billing_scope_id  = var.billing_scope_id
# }
# resource "azurerm_subscription" "platform_dev" {
#     subscription_name = "Platform-Dev"
#     billing_scope_id  = var.billing_scope_id
# }
// Management Group Subscriptions (landing zone)
# resource "azurerm_management_group_subscription_association" "dev" {
#   subscription_id     = data.azurerm_subscription.current.id
#   management_group_id = azurerm_management_group.dev.id
# }
resource "azurerm_management_group_subscription_association" "prod" {
  subscription_id     = data.azurerm_subscription.current.id
  management_group_id = azurerm_management_group.prod.id
}

data "azurerm_subscription" "current" {}
data "azurerm_client_config" "current" {}
