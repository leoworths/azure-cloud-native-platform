# ==============================
# Resource Groups
# ==============================
output "hub_rg_name" {
  value = azurerm_resource_group.hub_rg.name
}
output "hub_rg_location" {
  value = azurerm_resource_group.hub_rg.location
}
output "spoke_rg_name" {
  value = azurerm_resource_group.spoke_rg.name
}
output "spoke_rg_location" {
  value = azurerm_resource_group.spoke_rg.location
}
output "platform_rg_name" {
  value = azurerm_resource_group.platform_rg.name
}
output "platform_rg_location" {
  value = azurerm_resource_group.platform_rg.location
}
output "dns_rg_name" {
  value = azurerm_resource_group.dns_rg.name
}
output "dns_rg_location" {
  value = azurerm_resource_group.dns_rg.location
}

# ==============================
# Virtual Networks
# ==============================
output "hub_vnet_id" {
  value = azurerm_virtual_network.hub_vnet.id
}
output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke_vnet.id
}

# ==============================
# Subnets
# ==============================
output "firewall_subnet_id" {
  value = azurerm_subnet.firewall_subnet.id
}
output "bastion_subnet_id" {
  value = azurerm_subnet.bastion_subnet.id
}
output "app_gateway_subnet_id" {
  value = azurerm_subnet.app_gateway_subnet.id
}
output "aks_subnet_id" {
  value = azurerm_subnet.aks_subnet.id
}
output "postgres_subnet_id" {
  value = azurerm_subnet.postgres_subnet.id
}
output "private_endpoint_subnet_id" {
  value = azurerm_subnet.private_endpoint_subnet.id
}
output "jumpbox_subnet_id" {
  value = azurerm_subnet.jumpbox_subnet.id
}

# ==============================
# Log Analytics Workspace
# ==============================
output "log_analytics_workspace_id" {
  value = azurerm_log_analytics_workspace.log_analytics.id
}

# ==============================
# Azure Key Vault
# ==============================
output "keyvault_id" {
  value = azurerm_key_vault.keyvault.id
}
output "keyvault_name" {
  value = azurerm_key_vault.keyvault.name
}
output "keyvault_uri" {
  value = azurerm_key_vault.keyvault.vault_uri
}

# ==============================
# Azure Container Registry (ACR)
# ==============================
output "acr_id" {
  value = var.enable_acr ? azurerm_container_registry.acr[0].id : null
}
output "acr_login_server" {
  value = var.enable_acr ? azurerm_container_registry.acr[0].login_server : null
}

# ==============================
# Azure Firewall
# ==============================
output "firewall_id" {
  value = var.enable_firewall ? azurerm_firewall.hub_firewall[0].id : null
}
output "firewall_public_ip" {
  value = var.enable_firewall ? azurerm_public_ip.firewall_pip[0].ip_address : null
}

output "firewall_private_ip" {
  value = var.enable_firewall ? azurerm_firewall.hub_firewall[0].ip_configuration[0].private_ip_address : null
}

# ==============================
# NAT Gateway (Conditional)
# ==============================
output "nat_gateway_id" {
  value = var.enable_nat_gateway ? azurerm_nat_gateway.nat_gateway[0].id : null
}
output "nat_gateway_public_ip" {
  value = var.enable_nat_gateway ? azurerm_public_ip.nat_gateway_pip[0].ip_address : null
}

# ==============================
# Phase 1 Outputs Needed for Phase 3
# ==============================
# output "platform_admins_object_id" {
#   value = var.platform_admins_object_id
# }
# output "platform_operators_object_id" {
#   value = var.platform_operators_object_id
# }
# output "platform_developers_object_id" {
#   value = var.platform_developers_object_id
# }
# output "platform_readers_object_id" {
#   value = var.platform_readers_object_id
# }









# output "hub_rg_name" {
#   value = azurerm_resource_group.hub_rg.name
# }
# output "hub_rg_location" {
#   value = azurerm_resource_group.hub_rg.location
# }
# output "spoke_rg_name" {
#   value = azurerm_resource_group.spoke_rg.name
# }
# output "spoke_rg_location" {
#   value = azurerm_resource_group.spoke_rg.location
# }
# output "platform_rg_name" {
#   value = azurerm_resource_group.platform_rg.name
# }
# output "platform_rg_location" {
#   value = azurerm_resource_group.platform_rg.location
# }
# output "dns_rg_name" {
#   value = azurerm_resource_group.dns_rg.name
# }
# output "dns_rg_location" {
#   value = azurerm_resource_group.dns_rg.location
# }
# output "hub_vnet_id" {
#   value = azurerm_virtual_network.hub_vnet.id
# }
# output "spoke_vnet_id" {
#   value = azurerm_virtual_network.spoke_vnet.id
# }
# output "firewall_subnet_id" {
#   value = azurerm_subnet.firewall_subnet.id
# }
# output "bastion_subnet_id" {
#   value = azurerm_subnet.bastion_subnet.id
# }
# output "app_gateway_subnet_id" {
#   value = azurerm_subnet.app_gateway_subnet.id
# }
# output "aks_subnet_id" {
#   value = azurerm_subnet.aks_subnet.id
# }
# output "postgres_subnet_id" {
#   value = azurerm_subnet.postgres_subnet.id
# }
# output "private_endpoint_subnet_id" {
#   value = azurerm_subnet.private_endpoint_subnet.id
# }
# output "log_analytics_workspace_id" {
#   value = azurerm_log_analytics_workspace.log_analytics.id
# }

# output "keyvault_id" {
#   value = azurerm_key_vault.keyvault.id
# }
# output "keyvault_name" {
#   value = azurerm_key_vault.keyvault.name
# }
# output "keyvault_uri" {
#   value = azurerm_key_vault.keyvault.vault_uri
# }

# output "acr_id" {
#   value = azurerm_container_registry.acr.id
# }
# output "acr_login_server" {
#   value = azurerm_container_registry.acr.login_server
# }

# output "acr_id" {
#   value = var.enable_acr ? azurerm_container_registry.acr[0].id : null
# }
# output "acr_login_server" {
#   value = var.enable_acr ? azurerm_container_registry.acr[0].login_server : null
# }


# output "firewall_id" {
#   value = var.enable_firewall ? azurerm_firewall.hub_firewall[0].id : null
# }
    
# output "firewall_public_ip" {
#   value = var.enable_firewall ? azurerm_public_ip.firewall_pip[0].ip_address : null
# }


# output "firewall_private_ip" {
#   value = azurerm_firewall.hub_firewall.ip_configuration[0].private_ip_address
# }


# # Outputs From Phase 1 That Are Needed for Phase 3

# output "platform_admins_object_id" {
#   value = data.terraform_remote_state.identity.outputs.platform_admins_object_id
# }

# output "platform_operators_object_id" {
#   value = data.terraform_remote_state.identity.outputs.platform_operators_object_id
# }

# output "platform_developers_object_id" {
#   value = data.terraform_remote_state.identity.outputs.platform_developers_object_id
# }

# output "platform_readers_object_id" {
#   value = data.terraform_remote_state.identity.outputs.platform_readers_object_id
# }



