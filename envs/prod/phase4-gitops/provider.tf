provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 3.0"
    }
  }
}


provider "kubernetes" {
  host                   = data.terraform_remote_state.aks.outputs.kube_config_host
  client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.kube_config_client_certificate)
  client_key             = base64decode(data.terraform_remote_state.aks.outputs.kube_config_client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.kube_config_cluster_ca_certificate)
}

provider "helm" {
  kubernetes = {
    host                   = data.terraform_remote_state.aks.outputs.kube_config_host
    client_certificate     = base64decode(data.terraform_remote_state.aks.outputs.kube_config_client_certificate)
    client_key             = base64decode(data.terraform_remote_state.aks.outputs.kube_config_client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.aks.outputs.kube_config_cluster_ca_certificate)
  }
}





# provider "kubernetes" {
#   host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
#   client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
#   client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
#   cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
# }
# provider "helm" {
#   kubernetes = {
#     host                   = data.azurerm_kubernetes_cluster.aks.kube_config[0].host
#     client_certificate     = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_certificate)
#     client_key             = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].client_key)
#     cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.aks.kube_config[0].cluster_ca_certificate)
#   }
# }



