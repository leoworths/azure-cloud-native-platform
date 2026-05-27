module "aks_platform" {
  source = "../../../modules/aks-platform"

  environment = var.environment
  prefix      = var.prefix
  location    = var.location
  tags        = var.tags

  # -----------------------------------
  # Automated Feature Flags
  # -----------------------------------
  enable_firewall    = local.enable_firewall
  enable_nat_gateway = local.enable_nat_gateway
  enable_postgres    = local.enable_postgres
  enable_private_dns = local.enable_private_dns
  enable_private_aks = local.enable_private_aks

  # -----------------------------------
  # Remote State Values
  # -----------------------------------
  platform_rg_name     = data.terraform_remote_state.platform.outputs.platform_rg_name
  platform_rg_location = data.terraform_remote_state.platform.outputs.platform_rg_location

  spoke_rg_name     = data.terraform_remote_state.platform.outputs.spoke_rg_name
  spoke_rg_location = data.terraform_remote_state.platform.outputs.spoke_rg_location

  dns_rg_name   = data.terraform_remote_state.platform.outputs.dns_rg_name
  spoke_vnet_id = data.terraform_remote_state.platform.outputs.spoke_vnet_id

  aks_subnet_id      = data.terraform_remote_state.platform.outputs.aks_subnet_id
  postgres_subnet_id = data.terraform_remote_state.platform.outputs.postgres_subnet_id

  firewall_private_ip = try(
    data.terraform_remote_state.platform.outputs.firewall_private_ip,
    null
  )

  log_analytics_workspace_id = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id

  acr_id      = data.terraform_remote_state.platform.outputs.acr_id
  keyvault_id = data.terraform_remote_state.platform.outputs.keyvault_id

  platform_admins_object_id = data.terraform_remote_state.platform.outputs.platform_admins_object_id
}

# -----------------------------------
# Jumpbox AKS Access
# -----------------------------------
resource "azurerm_role_assignment" "jumpbox_aks_admin" {

  scope = module.aks_platform.aks_cluster_id

  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"

  principal_id = data.terraform_remote_state.platform.outputs.jumpbox_identity_principal_id
}



# module "aks_platform" {
#   source = "../../../modules/aks-platform"

#   environment = "dev"
#   prefix      = "3tier"
#   location    = var.location
#   tags        = var.tags

#   enable_firewall    = false
#   enable_nat_gateway = false
#   enable_postgres    = false
#   enable_private_dns = false
#   enable_private_aks = false

#   # PASS VALUES
#   platform_rg_name     = data.terraform_remote_state.platform.outputs.platform_rg_name
#   platform_rg_location = data.terraform_remote_state.platform.outputs.platform_rg_location

#   spoke_rg_name     = data.terraform_remote_state.platform.outputs.spoke_rg_name
#   spoke_rg_location = data.terraform_remote_state.platform.outputs.spoke_rg_location

#   dns_rg_name   = data.terraform_remote_state.platform.outputs.dns_rg_name
#   spoke_vnet_id = data.terraform_remote_state.platform.outputs.spoke_vnet_id

#   aks_subnet_id      = data.terraform_remote_state.platform.outputs.aks_subnet_id
#   postgres_subnet_id = data.terraform_remote_state.platform.outputs.postgres_subnet_id

#   firewall_private_ip = try(data.terraform_remote_state.platform.outputs.firewall_private_ip, null) 

#   log_analytics_workspace_id = data.terraform_remote_state.platform.outputs.log_analytics_workspace_id
#   acr_id                     = data.terraform_remote_state.platform.outputs.acr_id
#   keyvault_id                = data.terraform_remote_state.platform.outputs.keyvault_id

#   platform_admins_object_id = data.terraform_remote_state.platform.outputs.platform_admins_object_id
# }


# # ----------------------------
# # Allow Jumpbox to access AKS
# # ----------------------------
# resource "azurerm_role_assignment" "jumpbox_aks_admin" {
#   scope                = module.aks_platform.aks_cluster_id
#   role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
#   principal_id         = data.terraform_remote_state.platform.outputs.jumpbox_identity_principal_id
# }