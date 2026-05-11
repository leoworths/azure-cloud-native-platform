resource "azurerm_security_center_subscription_pricing" "aks" {
  tier          = "Standard"
  resource_type = "KubernetesService"
}

resource "azurerm_security_center_subscription_pricing" "kv" {
  tier          = "Standard"
  resource_type = "KeyVaults"
}