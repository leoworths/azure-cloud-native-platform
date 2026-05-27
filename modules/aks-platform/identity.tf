# Identity Workload for AKS Cluster
resource "azurerm_user_assigned_identity" "workload_identity" {
  name                = "workload-identity"
  resource_group_name = var.platform_rg_name
  location            = var.platform_rg_location
}

# Key Vault Role Assignment for Workload Identity 
resource "azurerm_role_assignment" "workload_keyvault" {
  scope                = var.keyvault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}

