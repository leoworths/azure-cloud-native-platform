resource "random_string" "kv_suffix" {
  length  = 5
  lower   = true
  numeric = true
  special = false
}

// Azure Key Vault resource
resource "azurerm_key_vault" "keyvault" {
  name                          = "${var.prefix}-${random_string.kv_suffix.result}-kv"
  location                      = azurerm_resource_group.platform_rg.location
  resource_group_name           = azurerm_resource_group.platform_rg.name
  tenant_id                     = data.azurerm_client_config.current.tenant_id
  sku_name                      = "standard"
  public_network_access_enabled = var.enable_private_endpoints ? false : true
  rbac_authorization_enabled    = true
  purge_protection_enabled      = true
  soft_delete_retention_days    = 7

  tags = local.common_tags
}
// Azure Key Vault RBAC Role Assignments
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

// Private DNS Zone for Key Vault
resource "azurerm_private_dns_zone" "kv_private_dns" {
    count = var.enable_private_endpoints ? 1 : 0 ## Only create if private endpoints are enabled
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.dns_rg.name
}
// Link Private DNS Zone to Spoke VNet
resource "azurerm_private_dns_zone_virtual_network_link" "kv_dns_vnet_link" {
    count = var.enable_private_endpoints ? 1 : 0 ## Only create if private endpoints are enabled
  name                  = "kv-dns-vnet-link"
  resource_group_name   = azurerm_resource_group.dns_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.kv_private_dns[0].name
  virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  registration_enabled  = false
  depends_on            = [azurerm_private_dns_zone.kv_private_dns]
}
// Private Endpoint(Spoke) for Key Vault
resource "azurerm_private_endpoint" "kv_private_endpoint" {
    count = var.enable_private_endpoints ? 1 : 0 ## Only create if private endpoints are enabled
  name                = "kv-private-endpoint"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  subnet_id           = azurerm_subnet.private_endpoint_subnet.id

  private_dns_zone_group {
    name                 = "kv-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.kv_private_dns[0].id] # Use index 0 since count is 1 when private endpoints are enabled
  }
  private_service_connection {
    name                           = "kv-privatelink"
    private_connection_resource_id = azurerm_key_vault.keyvault.id
    is_manual_connection           = false
    subresource_names              = ["vault"]
  }
  tags = local.common_tags
}
