# // managed devops pool for azure pipelines

# # ----------------------------
# # Identity for DevOps Pool
# # ----------------------------
# resource "azurerm_user_assigned_identity" "pool_identity" {
#   name                = "${var.prefix}-pool-identity"
#   location            = azurerm_resource_group.platform_rg.location
#   resource_group_name = azurerm_resource_group.platform_rg.name
# }

# # ----------------------------
# # Dev Center
# # ----------------------------
# resource "azurerm_dev_center" "devcenter" {
#   name                = "${var.prefix}-devcenter"
#   resource_group_name = azurerm_resource_group.platform_rg.name
#   location            = var.location
# }
# resource "azurerm_dev_center_project" "devcenter_project" {
#   name           = "${var.prefix}-devcenter-project"
#   resource_group_name = azurerm_resource_group.platform_rg.name
#   location       = var.location
#   dev_center_id  = azurerm_dev_center.devcenter.id
# }
# # ----------------------------
# # Managed DevOps Pool
# # ----------------------------
# resource "azurerm_managed_devops_pool" "managed_pool" {
#     name                = "devops-pool"
#     resource_group_name = azurerm_resource_group.platform_rg.name
#     location            = var.location
#     dev_center_project_id = azurerm_dev_center_project.devcenter_project.id
#     maximum_concurrency = 2
#     azure_devops_organization {
#         organization {
#             parallelism = 2
#             url = var.azure_devops_organization_url
#             projects = [var.azure_devops_project_name]
#         }
#         permission {
#             kind = "Inherit"
#         }
#     }
#     stateless_agent {
#         automatic_resource_prediction {
#             prediction_preference = "Balanced"
#         }
#     }
#     virtual_machine_scale_set_fabric {
#         sku_name = "Standard_D2ads_v5"
#         subnet_id = azurerm_subnet.jumpbox_subnet.id
#         image {
#             well_known_image_name = "ubuntu-24.04/latest"
#         }
#     }
#     identity {
#         type = "UserAssigned"
#         identity_ids = [azurerm_user_assigned_identity.pool_identity.id]
#     }
#     tags = local.common_tags
# }


# resource "azurerm_role_assignment" "agent_acr_push" {
#   count = var.enable_acr ? 1 : 0
#   scope                = azurerm_container_registry.acr[0].id
#   role_definition_name = "AcrPush"
#   principal_id         = azurerm_user_assigned_identity.pool_identity.principal_id
# }


# # Grant Key Vault Secrets User role to the pool identity
# resource "azurerm_role_assignment" "pool_keyvault" {
#   scope                = azurerm_key_vault.keyvault.id
#   role_definition_name = "Key Vault Secrets User"
#   principal_id         = azurerm_user_assigned_identity.pool_identity.principal_id
# }







# Grant ACR Push role to the pool identity

# resource "azurerm_role_assignment" "agent_acr_push" {
#   role_definition_name = "AcrPush"
#   scope                = azurerm_container_registry.acr.id
#   principal_id         = azurerm_user_assigned_identity.pool_identity.principal_id
# }
