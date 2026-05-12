output "argocd_namespace" {
  value = kubernetes_namespace_v1.argocd.metadata[0].name
}


# output "argocd_identity_client_id" {
#   value = azurerm_user_assigned_identity.argocd_identity.client_id
# }