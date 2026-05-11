# locals {
#   is_prod = var.environment == "prod"

#   aks_vm_size   = local.is_prod ? "Standard_D2_v3" : "Standard_D2s_v3"
#   aks_min_nodes = local.is_prod ? 2 : 1
#   aks_max_nodes = local.is_prod ? 5 : 1

#   postgres_sku = local.is_prod ? "Standard_D2s_v3" : "B_Standard_B1ms"

#   enable_firewall_routing = var.enable_firewall && local.is_prod
# }



locals {
  is_prod = var.environment == "prod"

  # ----------------------------
  # SYSTEM NODE POOL (AKS CORE)
  # ----------------------------
  system_vm_size = local.is_prod ? "Standard_D2s_v3" : "Standard_D2s_v3"

  system_min_nodes = 1
  system_max_nodes = local.is_prod ? 3 : 1

  # ----------------------------
  # USER NODE POOL (WORKLOADS)
  # ----------------------------
  user_vm_size = local.is_prod ? "Standard_D2s_v3" : "Standard_D2s_v3"

  user_min_nodes = 1
  user_max_nodes = local.is_prod ? 5 : 1

  # ----------------------------
  # DATABASE
  # ----------------------------
  postgres_sku = local.is_prod ? "Standard_D2s_v3" : "B_Standard_B1ms"

  # ----------------------------
  # NETWORKING
  # ----------------------------
  enable_firewall_routing = var.enable_firewall && local.is_prod
}