output "kube_config_host" {
  value     = module.aks_platform.kube_config_host
  sensitive = true
}

output "kube_config_client_certificate" {
  value     = module.aks_platform.kube_config_client_certificate
  sensitive = true
}

output "kube_config_client_key" {
  value     = module.aks_platform.kube_config_client_key
  sensitive = true
}

output "kube_config_cluster_ca_certificate" {
  value     = module.aks_platform.kube_config_cluster_ca_certificate
  sensitive = true
}

output "oidc_issuer_url" {
  value = module.aks_platform.oidc_issuer_url
}

output "aks_cluster_id" {
  value = module.aks_platform.aks_cluster_id
}

output "aks_cluster_name" {
  value = module.aks_platform.aks_cluster_name
}