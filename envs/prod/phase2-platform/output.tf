
# ==============================
# Resource Groups
# ==============================
output "hub_rg_name" {
  value = module.core_infra.hub_rg_name
}
output "hub_rg_location" {
  value = module.core_infra.hub_rg_location
}
output "spoke_rg_name" {
  value = module.core_infra.spoke_rg_name
}
output "spoke_rg_location" {
  value = module.core_infra.spoke_rg_location
}
output "platform_rg_name" {
  value = module.core_infra.platform_rg_name
}
output "platform_rg_location" {
  value = module.core_infra.platform_rg_location
}
output "dns_rg_name" {
  value = module.core_infra.dns_rg_name
}
output "dns_rg_location" {
  value = module.core_infra.dns_rg_location
}

# ==============================
# Networking
# ==============================
output "hub_vnet_id" {
  value = module.core_infra.hub_vnet_id
}
output "spoke_vnet_id" {
  value = module.core_infra.spoke_vnet_id
}
output "firewall_subnet_id" {
  value = module.core_infra.firewall_subnet_id
}
output "bastion_subnet_id" {
  value = module.core_infra.bastion_subnet_id
}
output "app_gateway_subnet_id" {
  value = module.core_infra.app_gateway_subnet_id
}
output "aks_subnet_id" {
  value = module.core_infra.aks_subnet_id
}
output "postgres_subnet_id" {
  value = module.core_infra.postgres_subnet_id
}
output "private_endpoint_subnet_id" {
  value = module.core_infra.private_endpoint_subnet_id

}
output "jumpbox_subnet_id" {
  value = module.core_infra.jumpbox_subnet_id
}



output "jumpbox_private_ip" {
  value = module.core_infra.jumpbox_private_ip
}
output "jumpbox_id" {
  value = module.core_infra.jumpbox_id
}

output "jumpbox_public_ip" {
  value = module.core_infra.jumpbox_public_ip
}
output "jumpbox_identity_principal_id" {
  value = module.core_infra.jumpbox_identity_principal_id
}





output "bastion_host_id" {
  value = module.core_infra.bastion_host_id
}
output "bastion_public_ip" {
  value = module.core_infra.bastion_public_ip
}



# ==============================
# Key Vault
# ==============================
output "keyvault_id" {
  value = module.core_infra.keyvault_id
}
output "keyvault_name" {
  value = module.core_infra.keyvault_name
}
output "keyvault_uri" {
  value = module.core_infra.keyvault_uri
}
# ==============================
# Observability
# ==============================
output "log_analytics_workspace_id" {
  value = module.core_infra.log_analytics_workspace_id
}
# ==============================
# Container Registry (ACR)
# ==============================
output "acr_id" {
  value = module.core_infra.acr_id
}
output "acr_login_server" {
  value = module.core_infra.acr_login_server
}
# ==============================
# Firewall
# ==============================
output "firewall_id" {
  value = module.core_infra.firewall_id
}
output "firewall_public_ip" {
  value = module.core_infra.firewall_public_ip
}
output "firewall_private_ip" {
  value = module.core_infra.firewall_private_ip
}
# ==============================
# NAT Gateway
# ==============================
output "nat_gateway_id" {
  value = module.core_infra.nat_gateway_id
}
# ==============================
# Phase 1 / Identity (for later phases)
# ==============================
output "platform_admins_object_id" {
  value = data.terraform_remote_state.identity.outputs.platform_admins_object_id
}
output "platform_operators_object_id" {
  value = data.terraform_remote_state.identity.outputs.platform_operators_object_id
}
output "platform_developers_object_id" {
  value = data.terraform_remote_state.identity.outputs.platform_developers_object_id
}
output "platform_readers_object_id" {
  value = data.terraform_remote_state.identity.outputs.platform_readers_object_id
}