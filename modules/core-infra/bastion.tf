resource "azurerm_public_ip" "bastion_pip" {
  name                = "bastion-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
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
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
  tags = local.common_tags
}



# ==============================
# Outputs
# ==============================
output "bastion_host_id" {
  value = azurerm_bastion_host.bastion.id
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_pip.ip_address
}

