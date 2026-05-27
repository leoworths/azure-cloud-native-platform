// --------------------
// Private DNS Zone for PostgreSQL
// --------------------
resource "azurerm_private_dns_zone" "postgres_private_dns" {
  count               = var.enable_postgres ? 1 : 0
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.dns_rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "postgres_dns_vnet_link" {
  count                 = var.enable_postgres ? 1 : 0
  name                  = "postgres-dns-vnet-link"
  resource_group_name   = var.dns_rg_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres_private_dns[0].name
  virtual_network_id    = var.spoke_vnet_id
  registration_enabled  = false
}

// --------------------
// PostgreSQL Flexible Server
// --------------------
resource "random_password" "postgres_admin_password" {
  length  = 16
  special = true
}

resource "azurerm_postgresql_flexible_server" "postgres_server" {
  count                         = var.enable_postgres ? 1 : 0
  name                          = "${var.prefix}-postgres-server"
  resource_group_name           = var.spoke_rg_name
  location                      = var.spoke_rg_location
  version                       = "16"
  administrator_login           = "pgadmin"
  administrator_password        = random_password.postgres_admin_password.result
  sku_name                      = "B_Standard_B1ms"
  delegated_subnet_id           = var.postgres_subnet_id
  private_dns_zone_id           = azurerm_private_dns_zone.postgres_private_dns[0].id
  public_network_access_enabled = false
  lifecycle {
    ignore_changes              = [zone]
  }

}

// --------------------
// PostgreSQL Flexible Database
// --------------------
resource "azurerm_postgresql_flexible_server_database" "app_database" {
  count                         = var.enable_postgres ? 1 : 0
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.postgres_server[0].id
  charset   = "UTF8"
  collation = "en_US.utf8"

  lifecycle {
    prevent_destroy = false
  }
}
// --------------------
// Secrets
// --------------------
# resource "azurerm_key_vault_secret" "postgres_admin_password" {
#   name         = "postgres-admin-password"
#   value        = random_password.postgres_admin_password.result
#   key_vault_id = var.keyvault_id
# }


output "postgres_server_name" {
  description = "PostgreSQL server name"
  value       = var.enable_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].name : null
}

output "postgres_server_id" {
  description = "PostgreSQL server ID"
  value       = var.enable_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].id : null
}

output "postgres_server_fqdn" {
  description = "PostgreSQL FQDN"
  value       = var.enable_postgres ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null
}

# output "postgres_server_name" {
#   value = azurerm_postgresql_flexible_server.postgres_server.name
# }

# output "postgres_server_id" {
#   value = azurerm_postgresql_flexible_server.postgres_server.id
# }

# output "postgres_server_fqdn" {
#   value = azurerm_postgresql_flexible_server.postgres_server.fqdn
# }