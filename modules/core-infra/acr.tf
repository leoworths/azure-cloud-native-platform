// ==============================
// Azure Container Registry (ACR)
// ==============================
resource "azurerm_container_registry" "acr" {
  name                          = "3tieracr"
  count                         = var.enable_acr ? 1 : 0
  resource_group_name           = azurerm_resource_group.platform_rg.name
  location                      = azurerm_resource_group.platform_rg.location
  sku                           = var.acr_sku
  admin_enabled                 = false
  public_network_access_enabled = var.acr_sku == "Premium" ? false : true # Allow public access for non-premium SKUs
  data_endpoint_enabled         = var.acr_sku == "Premium" ? true : false

  identity {
    type = "SystemAssigned"
  }

  tags = local.common_tags
}

// ==============================
// Private DNS Zone for ACR
// ==============================
resource "azurerm_private_dns_zone" "acr_private_dns" {
  count               = var.enable_acr ? 1 : 0
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.dns_rg.name
}

// ==============================
// Link Private DNS Zone to Spoke VNet
// ==============================
resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_vnet_link" {
  count                 = var.enable_acr ? 1 : 0
  name                  = "acr-dns-vnet-link"
  resource_group_name   = azurerm_resource_group.dns_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_private_dns[0].name
  virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
  registration_enabled  = false

  depends_on = [azurerm_private_dns_zone.acr_private_dns]

}

// ==============================
// Private Endpoint (Spoke) for ACR
// ==============================
resource "azurerm_private_endpoint" "acr_private_endpoint" {
  count               = var.enable_private_endpoints && var.enable_acr ? 1 : 0
  name                 = "acr-private-endpoint"
  location             = azurerm_resource_group.spoke_rg.location
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  subnet_id            = azurerm_subnet.private_endpoint_subnet.id

  private_dns_zone_group {
    name                 = "acr-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_private_dns[0].id]
  }

  private_service_connection {
    name                           = "acr-privatelink"
    private_connection_resource_id = azurerm_container_registry.acr[0].id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.acr_dns_vnet_link
  ]
    tags = local.common_tags
}




# // Azure Container Registry (Private ACR) 
# resource "azurerm_container_registry" "acr" {
#   name                          = "3tieracr"
#   resource_group_name           = azurerm_resource_group.platform_rg.name
#   location                      = azurerm_resource_group.platform_rg.location
#   sku                           = "Standard"
#   admin_enabled                 = false
#   public_network_access_enabled = false
#   data_endpoint_enabled         = true # Enable data endpoint for premium SKU

#   identity {
#     type = "SystemAssigned"
#   }

#   tags = var.tags
# }

# // Private DNS Zone for ACR
# resource "azurerm_private_dns_zone" "acr_private_dns" {
#   name                = "privatelink.azurecr.io"
#   resource_group_name = azurerm_resource_group.dns_rg.name
# }

# // Link Private DNS Zone to Spoke VNet
# resource "azurerm_private_dns_zone_virtual_network_link" "acr_dns_vnet_link" {
#   name                  = "acr-dns-vnet-link"
#   resource_group_name   = azurerm_resource_group.dns_rg.name
#   private_dns_zone_name = azurerm_private_dns_zone.acr_private_dns.name
#   virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
#   registration_enabled  = false
#   depends_on            = [azurerm_private_dns_zone.acr_private_dns]
# }
# // Private Endpoint(Spoke) for ACR
# resource "azurerm_private_endpoint" "acr_private_endpoint" {
#   name                = "acr-private-endpoint"
#   location            = azurerm_resource_group.spoke_rg.location
#   resource_group_name = azurerm_resource_group.spoke_rg.name
#   subnet_id           = azurerm_subnet.private_endpoint_subnet.id

#   private_dns_zone_group {
#     name                 = "acr-dns-zone-group"
#     private_dns_zone_ids = [azurerm_private_dns_zone.acr_private_dns.id]
#   }

#   private_service_connection {
#     name                           = "acr-privatelink"
#     private_connection_resource_id = azurerm_container_registry.acr.id
#     is_manual_connection           = false
#     subresource_names              = ["registry"]
#   }
# }
