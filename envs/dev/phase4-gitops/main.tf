# resource "kubernetes_namespace_v1" "argocd" {
#   metadata {
#     name = "argocd"
#   }
# }

# resource "kubernetes_service_account_v1" "repo_server" {
#   metadata {
#     name      = "argocd-server"
#     namespace = "argocd"

#     annotations = {
#       "azure.workload.identity/client-id" = azurerm_user_assigned_identity.argocd.client_id
#     }

#     labels = {
#       "azure.workload.identity/use" = "true"
#     }
#   }
# }

# resource "helm_release" "argocd" {
#   name       = "argocd"
#   namespace  = "argocd"
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"

#   values = [
#     file("${path.module}/values/argocd-values.yaml")
#   ]

#   depends_on = [kubernetes_service_account_v1.repo_server]
# }