resource "azurerm_user_assigned_identity" "jumpbox_identity" {
  name                = "jumpbox-identity"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
}

#Public ip creation
resource "azurerm_public_ip" "jumpbox_pip" {
  count               = var.enable_jumpbox_public_ip ? 1 : 0
  name                = "jumpbox-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = local.common_tags
}


# NSG for Agent Subnet
resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "jumpbox-nsg"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name

  security_rule {
    name                       = "AllowOutboundHttps"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowBastionSSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    #source_address_prefix      = "VirtualNetwork" // 🔴 change this
    source_address_prefix      = var.enable_jumpbox_public_ip ? "*" : "VirtualNetwork"
    destination_address_prefix = "*"
  }

#   security_rule {
#   name                       = "AllowSSHFromMyIP"
#   priority                   = 200
#   direction                  = "Inbound"
#   access                     = "Allow"
#   protocol                   = "Tcp"
#   source_port_range          = "*"
#   destination_port_range     = "22"
#   source_address_prefix      = "*" # 👈 YOUR IP
#   destination_address_prefix = "*"
# }
  # Deny everything else
  security_rule {
    name                       = "DenyAllInbound"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    source_port_range          = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "jumpbox_subnet_nsg" {
  subnet_id                 = azurerm_subnet.jumpbox_subnet.id
  network_security_group_id = azurerm_network_security_group.jumpbox_nsg.id
}

#network interface creation
resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "jumpbox-nic"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.jumpbox_subnet.id
    private_ip_address_allocation = "Dynamic"
    #public_ip_address_id          = var.enable_jumpbox_public_ip ? azurerm_public_ip.jumpbox_pip[0].id : null
    public_ip_address_id          = azurerm_public_ip.jumpbox_pip[0].id
  }
  tags = local.common_tags
}

#virtual machine creation (Self Hosted Agent)
resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                = "jumpbox"
  resource_group_name = azurerm_resource_group.spoke_rg.name
  location            = azurerm_resource_group.spoke_rg.location
  size                =  "Standard_D2s_v3" # "Standard_B2s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.jumpbox_nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(pathexpand(var.ssh_public_key))
  }
  custom_data = base64encode(file("${path.module}/cloud-init.sh"))


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.jumpbox_identity.id]
  }
}

# resource "azurerm_role_assignment" "agent_acr_push" {
#   scope                = azurerm_container_registry.acr.id
#   role_definition_name = "AcrPush"
#   principal_id         = azurerm_user_assigned_identity.jumpbox_identity.principal_id
# }


resource "azurerm_role_assignment" "agent_acr_push" {
  count = var.enable_acr ? 1 : 0
  scope                = azurerm_container_registry.acr[0].id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.jumpbox_identity.principal_id
}
// rbac for keyvault access if needed
resource "azurerm_role_assignment" "jumpbox_keyvault" {
  scope                = azurerm_key_vault.keyvault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = azurerm_user_assigned_identity.jumpbox_identity.principal_id
}


# ==============================
# Jumpbox Outputs
# ==============================
output "jumpbox_private_ip" {
  value = azurerm_network_interface.jumpbox_nic.private_ip_address
}

output "jumpbox_id" {
  value = azurerm_linux_virtual_machine.jumpbox.id
}
output "jumpbox_public_ip" {
  value = var.enable_jumpbox_public_ip ? azurerm_public_ip.jumpbox_pip[0].ip_address : null
}
output "jumpbox_identity_principal_id" {
  value = azurerm_user_assigned_identity.jumpbox_identity.principal_id
}
