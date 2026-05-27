resource "azurerm_resource_group" "hub_rg" {
  name     = "${var.prefix}-hub-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "spoke_rg" {
  name     = "${var.prefix}-spoke-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "platform_rg" {
  name     = "platform-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_resource_group" "dns_rg" {
  name     = "${var.prefix}-dns-rg"
  location = var.location
  tags     = local.common_tags
}