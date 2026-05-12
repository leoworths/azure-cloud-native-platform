# ----------------------------
# Private DNS Zone for AKS
# ----------------------------
# resource "azurerm_private_dns_zone" "aks_private_dns" {
#   count = var.enable_private_dns ? 1 : 0
#   name                = "privatelink.${var.location}.azmk8s.io"
#   resource_group_name = var.dns_rg_name
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "aks_dns_vnet_link" {
#   count = var.enable_private_dns ? 1 : 0
#   name                  = "aks-dns-vnet-link"
#   resource_group_name   = var.dns_rg_name
#   private_dns_zone_name = azurerm_private_dns_zone.aks_private_dns[0].name
#   virtual_network_id    = var.spoke_vnet_id
#   registration_enabled  = false
# }

# ----------------------------
# AKS Identity
# ----------------------------
resource "azurerm_user_assigned_identity" "aks_identity" {
  name                = "${var.prefix}-aks-identity"
  location            = var.spoke_rg_location
  resource_group_name = var.spoke_rg_name
}

# DNS Role Assignment
# resource "azurerm_role_assignment" "aks_dns_contributor" {
#   count = var.enable_private_dns ? 1 : 0
#   scope                = azurerm_private_dns_zone.aks_private_dns[0].id
#   role_definition_name = "Private DNS Zone Contributor"
#   principal_id         = azurerm_user_assigned_identity.aks_identity.principal_id
# }

# ----------------------------
# AKS Cluster
# ----------------------------
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.prefix}-aks"
  location            = var.spoke_rg_location
  resource_group_name = var.spoke_rg_name
  dns_prefix          = "${var.prefix}-aks"

  # Zero Trust
  private_cluster_enabled             = true
  private_cluster_public_fqdn_enabled = false
  local_account_disabled              = true

  # Identity & Security
  oidc_issuer_enabled       = true
  workload_identity_enabled = true
  azure_policy_enabled      = true
  private_dns_zone_id       = "System"
  #private_dns_zone_id = var.enable_private_dns ? azurerm_private_dns_zone.aks_private_dns[0].id : null

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
  }

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = [var.platform_admins_object_id]
    azure_rbac_enabled = true
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "calico"
    load_balancer_sku = "standard"

    outbound_type = var.enable_nat_gateway ? "userAssignedNATGateway" : (
      local.is_prod && var.enable_firewall ? "userDefinedRouting" : "loadBalancer"
    )
    #outbound_type = local.is_prod && var.enable_firewall ? "userDefinedRouting" : "loadBalancer"
  }

  default_node_pool {
    name                         = "system"
    vm_size                      = local.system_vm_size
    auto_scaling_enabled         = true
    min_count                    = local.system_min_nodes
    max_count                    = local.system_max_nodes
    max_pods                     = 50
    vnet_subnet_id               = var.aks_subnet_id

    only_critical_addons_enabled = true
    os_disk_size_gb              = 30
    os_sku                       = "AzureLinux3"
    #temporary_name_for_rotation  = "systemtmp"
  }
  auto_scaler_profile {
  balance_similar_node_groups      = true
  expander                         = "least-waste"
  scale_down_delay_after_add       = "10m"
  scale_down_unneeded              = "10m"
  scale_down_unready               = "20m"
  max_graceful_termination_sec     = 600
}
  # Monitoring
  # oms_agent {
  #   log_analytics_workspace_id = var.log_analytics_workspace_id
  # }
  monitor_metrics {
    annotations_allowed = true
  }
  # Secrets (Zero Trust)
  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2h"
  }
  image_cleaner_enabled = true
  image_cleaner_interval_hours = 24
  # Autoscaling
  workload_autoscaler_profile {
    keda_enabled = true # Enable KEDA for event-driven scaling
  }
  tags = var.tags
}

# ----------------------------
# User Node Pool
# ----------------------------
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id

  vm_size = local.user_vm_size

  auto_scaling_enabled = true
  min_count            = local.user_min_nodes
  max_count            = local.user_max_nodes

  # Cost optimization
  priority        = local.is_prod ? "Regular" : "Spot"
  eviction_policy = local.is_prod ? null : "Deallocate"
  spot_max_price  = local.is_prod ? null : -1

  vnet_subnet_id = var.aks_subnet_id
  os_disk_size_gb = 30
  os_sku          = "AzureLinux3"
  mode            = "User"
}

# ----------------------------
# ACR Pull Access
# ----------------------------
# resource "azurerm_role_assignment" "aks_acr_pull" {
#   scope                = var.acr_id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
# }

resource "azurerm_role_assignment" "aks_acr_pull" {
  count = var.acr_id != null ? 1 : 0
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}



# ----------------------------
# Route Table (ONLY for Prod)
# ----------------------------
resource "azurerm_route_table" "aks_route_table" {
  count = local.is_prod && var.enable_firewall ? 1 : 0

  name                = "${var.prefix}-aks-rt"
  location            = var.spoke_rg_location
  resource_group_name = var.spoke_rg_name

  bgp_route_propagation_enabled = false

  route {
    name                   = "default-to-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip
  }
}

resource "azurerm_subnet_route_table_association" "aks_subnet_route_assoc" {
  count = local.is_prod && var.enable_firewall ? 1 : 0

  subnet_id      = var.aks_subnet_id
  route_table_id = azurerm_route_table.aks_route_table[0].id
}










# # ----------------------------
# # AKS Identity
# # ----------------------------
# resource "azurerm_user_assigned_identity" "aks_identity" {
#   name                = "${var.prefix}-aks-identity"
#   location            = var.spoke_rg_location
#   resource_group_name = var.spoke_rg_name
# }

# # ----------------------------
# # AKS Cluster
# # ----------------------------
# resource "azurerm_kubernetes_cluster" "aks" {
#   name                = "${var.prefix}-aks"
#   location            = var.spoke_rg_location
#   resource_group_name = var.spoke_rg_name
#   dns_prefix          = "${var.prefix}-aks"

#   # ----------------------------
#   # Zero Trust
#   # ----------------------------
#   private_cluster_enabled             = true
#   private_cluster_public_fqdn_enabled = false
#   private_dns_zone_id                 = "System"   # ✅ FIXED (CRITICAL)
#   local_account_disabled              = true

#   # ----------------------------
#   # Identity & Security
#   # ----------------------------
#   oidc_issuer_enabled       = true
#   workload_identity_enabled = true
#   azure_policy_enabled      = true

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.aks_identity.id]
#   }

#   azure_active_directory_role_based_access_control {
#     admin_group_object_ids = [var.platform_admins_object_id]
#     azure_rbac_enabled     = true
#   }

#   # ----------------------------
#   # Networking
#   # ----------------------------
#   network_profile {
#     network_plugin    = "azure"
#     network_policy    = "calico"
#     load_balancer_sku = "standard"

#     outbound_type = local.is_prod && var.enable_firewall ? "userDefinedRouting" : "loadBalancer"
#   }

#   # ----------------------------
#   # System Node Pool
#   # ----------------------------
#   default_node_pool {
#     name                         = "system"
#     vm_size                      = local.system_vm_size
#     auto_scaling_enabled         = true
#     min_count                    = local.system_min_nodes
#     max_count                    = local.system_max_nodes
#     max_pods                     = 50
#     vnet_subnet_id               = var.aks_subnet_id

#     only_critical_addons_enabled = true
#     os_disk_size_gb              = 30
#     os_sku                       = "AzureLinux3"
#   }

#   # ----------------------------
#   # Autoscaler tuning
#   # ----------------------------
#   auto_scaler_profile {
#     balance_similar_node_groups  = true
#     expander                     = "least-waste"
#     scale_down_delay_after_add   = "10m"
#     scale_down_unneeded          = "10m"
#     scale_down_unready           = "20m"
#     max_graceful_termination_sec = 600
#   }

#   # ----------------------------
#   # Monitoring
#   # ----------------------------
#   monitor_metrics {
#     annotations_allowed = "true"
#   }

#   # ----------------------------
#   # Secrets (Zero Trust)
#   # ----------------------------
#   key_vault_secrets_provider {
#     secret_rotation_enabled  = true
#     secret_rotation_interval = "2h"
#   }

#   # ----------------------------
#   # Image Cleanup
#   # ----------------------------
#   image_cleaner_enabled        = true
#   image_cleaner_interval_hours = 24

#   # ----------------------------
#   # Workload Autoscaler
#   # ----------------------------
#   workload_autoscaler_profile {
#     keda_enabled = true
#   }

#   tags = var.tags
# }

# # ----------------------------
# # User Node Pool
# # ----------------------------
# resource "azurerm_kubernetes_cluster_node_pool" "user" {
#   name                  = "user"
#   kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id

#   vm_size = local.user_vm_size

#   auto_scaling_enabled = true
#   min_count            = local.user_min_nodes
#   max_count            = local.user_max_nodes

#   # Cost optimization
#   priority        = local.is_prod ? "Regular" : "Spot"
#   eviction_policy = local.is_prod ? null : "Delete"
#   spot_max_price  = local.is_prod ? null : -1

#   vnet_subnet_id  = var.aks_subnet_id
#   os_disk_size_gb = 30
#   os_sku          = "AzureLinux3"
#   mode            = "User"
# }

# # ----------------------------
# # ACR Pull Access
# # ----------------------------
# resource "azurerm_role_assignment" "aks_acr_pull" {
#   count = var.acr_id != null ? 1 : 0

#   scope                = var.acr_id
#   role_definition_name = "AcrPull"
#   principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
# }

# # ----------------------------
# # Route Table (ONLY for Prod)
# # ----------------------------
# resource "azurerm_route_table" "aks_route_table" {
#   count = local.is_prod && var.enable_firewall ? 1 : 0

#   name                = "${var.prefix}-aks-rt"
#   location            = var.spoke_rg_location
#   resource_group_name = var.spoke_rg_name

#   bgp_route_propagation_enabled = false

#   route {
#     name                   = "default-to-firewall"
#     address_prefix         = "0.0.0.0/0"
#     next_hop_type          = "VirtualAppliance"
#     next_hop_in_ip_address = var.firewall_private_ip
#   }
# }

# resource "azurerm_subnet_route_table_association" "aks_subnet_route_assoc" {
#   count = local.is_prod && var.enable_firewall ? 1 : 0

#   subnet_id      = var.aks_subnet_id
#   route_table_id = azurerm_route_table.aks_route_table[0].id
# }