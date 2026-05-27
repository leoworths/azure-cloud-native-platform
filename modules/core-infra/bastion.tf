resource "azurerm_public_ip" "bastion_pip" {
  count               = var.enable_bastion ? 1 : 0
  name                = "bastion-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}

resource "azurerm_bastion_host" "bastion" {
  count               = var.enable_bastion ? 1 : 0
  name                = "bastion"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku                 = "Standard"
  scale_units         = "2"
  copy_paste_enabled  = true
  file_copy_enabled   = true
  tunneling_enabled   = true
  ip_connect_enabled  = true
  shareable_link_enabled = false

  ip_configuration {
    name                 = "bastion-config"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip[0].id
  }
  tags = local.common_tags
}



# ==============================
# Outputs
# ==============================
# output "bastion_host_id" {
#   value = azurerm_bastion_host.bastion.id
# }

# output "bastion_public_ip" {
#   value = azurerm_public_ip.bastion_pip.ip_address
# }

output "bastion_host_id" {
  value = var.enable_bastion ? azurerm_bastion_host.bastion[0].id : null
}
output "bastion_public_ip" {
  value = var.enable_bastion ? azurerm_public_ip.bastion_pip[0].ip_address : null
}
