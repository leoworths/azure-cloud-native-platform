# output "aks_cluster_id" {
#   value = azurerm_kubernetes_cluster.aks.id
# }
# output "aks_cluster_name" {
#   value = azurerm_kubernetes_cluster.aks.name
# }
# output "aks_private_fqdn" {
#   value = azurerm_kubernetes_cluster.aks.private_fqdn
# }
# output "aks_kube_config" {
#   value     = azurerm_kubernetes_cluster.aks.kube_config_raw
#   sensitive = true
# }
# output "oidc_issuer_url" {
#   value = azurerm_kubernetes_cluster.aks.oidc_issuer_url
# }
# output "workload_identity_client_id" {
#   value = azurerm_user_assigned_identity.workload_identity.client_id
# }
# output "workload_identity_principal_id" {
#   value = azurerm_user_assigned_identity.workload_identity.principal_id
# }

# output "postgres_server_name" {
#   value = azurerm_postgresql_flexible_server.postgres_server.name
# }

# output "postgres_server_id" {
#   value = azurerm_postgresql_flexible_server.postgres_server.id
# }

# output "postgres_server_fqdn" {
#   value = azurerm_postgresql_flexible_server.postgres_server.fqdn
# }





# --- AKS ---
output "aks_cluster_id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "aks_private_fqdn" {
  value = azurerm_kubernetes_cluster.aks.private_fqdn
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.aks.oidc_issuer_url
}

# --- Kubeconfig (for Terraform providers) ---
output "kube_config_host" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].host
}

output "kube_config_client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate
}

output "kube_config_client_key" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].client_key
}

output "kube_config_cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate
}

# --- Identity ---
output "workload_identity_client_id" {
  value = azurerm_user_assigned_identity.workload_identity.client_id
}

output "workload_identity_principal_id" {
  value = azurerm_user_assigned_identity.workload_identity.principal_id
}

# --- Database ---
# output "postgres_server_name" {
#   value = azurerm_postgresql_flexible_server.postgres_server.name
# }

# output "postgres_server_id" {
#   value = azurerm_postgresql_flexible_server.postgres_server.id
# }

# output "postgres_server_fqdn" {
#   value = azurerm_postgresql_flexible_server.postgres_server.fqdn
# }