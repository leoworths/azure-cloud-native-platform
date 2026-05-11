// Argocd Workload Identity
resource "azurerm_user_assigned_identity" "argocd_identity" {
  name                = "argocd-identity"
  resource_group_name = data.terraform_remote_state.platform.outputs.platform_rg_name
  location            = data.terraform_remote_state.platform.outputs.platform_rg_location
}

// Federated Identity Credential for ArgoCD
resource "azurerm_federated_identity_credential" "argocd_credential" {
  name                      = "argocd-credential"
  user_assigned_identity_id = azurerm_user_assigned_identity.argocd_identity.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = data.terraform_remote_state.aks.outputs.oidc_issuer_url
  subject                   = "system:serviceaccount:argocd:argocd-server"
}
// ACR Pull Permission for ArgoCD
resource "azurerm_role_assignment" "argocd_acr_pull" {
  scope                = data.terraform_remote_state.platform.outputs.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.argocd_identity.principal_id
}

