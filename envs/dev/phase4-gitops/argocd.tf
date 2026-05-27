# // GitOps with Argo CD

# resource "kubernetes_namespace_v1" "argocd" {
#   metadata {
#     name = "argocd"
#   }
# }
# # Service Account Annotation for Workload Identity

# resource "kubernetes_service_account_v1" "argocd_server" {
#   metadata {
#     name      = "argocd-server"
#     namespace = kubernetes_namespace_v1.argocd.metadata[0].name
#     annotations = {
#       "azure.workload.identity/client-id" = azurerm_user_assigned_identity.argocd_identity.client_id
#     }
#     labels = {
#       "azure.workload.identity/use" = "true"
#     }
#   }
# }
# // Argo CD Installation (Helm)
# resource "helm_release" "argocd" {
#   name       = "argocd"
#   namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"
#   values = [
#     <<-EOT
#       repoServer:
#         podLabels:
#           azure.workload.identity/use: "true"

#         serviceAccount:
#           create: false
#           name: argocd-server

#       server:
#         service:
#           type: LoadBalancer
#           annotations:
#             service.beta.kubernetes.io/azure-load-balancer-internal: "true"

#       configs:
#         rbac:
#           policy.default: role:readonly
#         params:
#           server.insecure: true
#     EOT
#   ]
# }






