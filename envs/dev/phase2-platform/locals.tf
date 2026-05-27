locals {

  # -----------------------------------
  # Environment Detection
  # -----------------------------------
  is_prod = var.environment == "prod"


  # Disabled in BOTH dev and prod
  enable_firewall = false

  # Enabled ONLY in prod
  enable_bastion = local.is_prod

  # Enabled ONLY in prod
  enable_private_endpoints = local.is_prod

  # Enabled ONLY in prod
  enable_private_dns = local.is_prod


  # NAT Gateway only in prod
  enable_nat_gateway = local.is_prod

  # Public jumpbox only in dev
  enable_jumpbox_public_ip = !local.is_prod


  # Premium for prod, Basic for dev
  acr_sku = local.is_prod ? "Premium" : "Basic"
}