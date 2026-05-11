
// ==============================
// NAT Gateway Public IP
// ==============================
resource "azurerm_public_ip" "nat_gateway_pip" {
    count = var.enable_nat_gateway ? 1 : 0 ## Only create if NAT Gateway is enabled
  name                = "nat-gateway-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

// ==============================
// NAT Gateway
// ==============================
resource "azurerm_nat_gateway" "nat_gateway" {
    count = var.enable_nat_gateway ? 1 : 0 ## Only create if NAT Gateway is enabled
  name                   = "nat-gateway"
  location               = azurerm_resource_group.hub_rg.location
  resource_group_name    = azurerm_resource_group.hub_rg.name
  sku_name               = "Standard"
  idle_timeout_in_minutes = 10
}

// ==============================
// NAT Gateway Public IP Association
// ==============================
resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_assoc" {
    count = var.enable_nat_gateway ? 1 : 0 ## Only create if NAT Gateway is enabled
  nat_gateway_id       = azurerm_nat_gateway.nat_gateway[0].id
  public_ip_address_id = azurerm_public_ip.nat_gateway_pip[0].id
}

// ==============================
// Associate AKS Subnet to NAT Gateway
// ==============================
resource "azurerm_subnet_nat_gateway_association" "aks_nat_assoc" {
  count = var.enable_nat_gateway ? 1 : 0
  subnet_id     = azurerm_subnet.aks_subnet.id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway[0].id
}

// ==============================
// NAT Gateway Outputs
// ==============================
# output "nat_gateway_id" {
#   value = var.enable_nat_gateway ? azurerm_nat_gateway.nat_gateway[0].id : null
# }

# output "nat_gateway_public_ip" {
#   value = var.enable_nat_gateway ? azurerm_public_ip.nat_gateway_pip[0].fqdn : null
# }











