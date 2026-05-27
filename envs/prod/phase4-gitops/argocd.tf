# # // GitOps with Argo CD

# resource "kubernetes_namespace_v1" "argocd" {
#   metadata {
#     name = "argocd"
#   }
# }
# resource "kubernetes_service_account_v1" "argocd_server" {
#   metadata {
#     name      = "argocd-server"
#     namespace = kubernetes_namespace_v1.argocd.metadata[0].name
#   }
# }

# resource "helm_release" "argocd" {
#   name       = "argocd"
#   namespace  = kubernetes_namespace_v1.argocd.metadata[0].name
#   repository = "https://argoproj.github.io/argo-helm"
#   chart      = "argo-cd"

#   values = [
#     <<-EOT
#       server:
#         service:
#           type: ClusterIP

#       configs:
#         rbac:
#           policy.default: role:readonly

#         params:
#           server.insecure: true

#       repoServer:
#         replicas: 2

#       applicationSet:
#         enabled: true
#     EOT
#   ]
# }




