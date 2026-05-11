// ==============================
// Firewall Public IP
// ==============================
resource "azurerm_public_ip" "firewall_pip" {
    count = var.enable_firewall ? 1 : 0 ## Only create if Firewall is enabled
  name                = "firewall-pip"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

// ==============================
// Firewall Policy
// ==============================
resource "azurerm_firewall_policy" "firewall_policy" {
        count = var.enable_firewall ? 1 : 0 ## Only create if Firewall is enabled
  name                      = "firewall-policy"
  location                  = azurerm_resource_group.hub_rg.location
  resource_group_name       = azurerm_resource_group.hub_rg.name
  threat_intelligence_mode  = "Alert"

  dns {
    proxy_enabled = true
  }
}

// ==============================
// Firewall Instance
// ==============================
resource "azurerm_firewall" "hub_firewall" {
        count = var.enable_firewall ? 1 : 0 ## Only create if Firewall is enabled
  name                = "hub-firewall"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy[0].id

  ip_configuration {
    name                 = "firewall-ip-config"
    subnet_id            = azurerm_subnet.firewall_subnet.id
    public_ip_address_id = azurerm_public_ip.firewall_pip[0].id
  }

  depends_on = [
    azurerm_firewall_policy.firewall_policy,
    azurerm_public_ip.firewall_pip
  ]
}

// ==============================
// Firewall Rules
// ==============================
resource "azurerm_firewall_policy_rule_collection_group" "firewall_rule" {
  count               = var.enable_firewall ? 1 : 0 ## Only create if Firewall is enabled
  name                = "firewall-rule"
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy[0].id
  priority            = 100


  application_rule_collection {
    name     = "rule-collection"
    priority = 100
    action   = "Allow"

    rule {
      name        = "firewall-policy-rule"
      description = "Allow HTTPS traffic"
      protocols {
        type = "Https"
        port = 443
      }

      source_addresses = ["10.1.0.0/16"]

      destination_fqdns = [
        "*.azurecr.io",
        "*.blob.core.windows.net",
        "*.microsoft.com",
        "*.database.azure.com",
        "*.ubuntu.com",
        "*.azmk8s.io",
        "*.vaultcore.azure.net"
      ]
    }
  }

  depends_on = [
    azurerm_firewall.hub_firewall
  ]
}

// ==============================
// Firewall Outputs
// ==============================


# output "firewall_id" {
#   value = var.enable_firewall ? azurerm_firewall.hub_firewall[0].id : null
# }
    
# output "firewall_public_ip" {
#   value = var.enable_firewall ? azurerm_public_ip.firewall_pip[0].ip_address : null
# }





