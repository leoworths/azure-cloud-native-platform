resource "azurerm_user_assigned_identity" "github_identity" {
  name                = "github-identity"
  resource_group_name = azurerm_resource_group.platform_rg.name
  location            = azurerm_resource_group.platform_rg.location
}
// Federated Identity Credential for GitHub Actions
resource "azurerm_federated_identity_credential" "github_credential" {
  name                = "github-credential"
  user_assigned_identity_id = azurerm_user_assigned_identity.github_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:leoworths/azure-cloud-native-platform:ref:refs/heads/main"
}
// Role Assignment for GitHub Actions to ACR Push
resource "azurerm_role_assignment" "github_acr_push" {
  count               = var.enable_acr ? 1 : 0
  scope               = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPush"
  principal_id       = azurerm_user_assigned_identity.github_identity.principal_id
}
