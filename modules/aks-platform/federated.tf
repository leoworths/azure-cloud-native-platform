# Federated Identities for Core Platform Services
resource "azurerm_federated_identity_credential" "workload_credential" {
  name                      = "workload-credential"
  user_assigned_identity_id = azurerm_user_assigned_identity.workload_identity.id
  audience                  = ["api://AzureADTokenExchange"]
  issuer                    = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject                   = "system:serviceaccount:todo-app:todo-sa"
}
