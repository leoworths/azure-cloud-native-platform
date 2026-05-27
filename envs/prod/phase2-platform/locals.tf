locals {

  # -----------------------------------
  # Environment Detection
  # -----------------------------------
  is_prod = var.environment == "prod"

  # -----------------------------------
  # Security Features
  # -----------------------------------
  enable_firewall = false

  enable_bastion = local.is_prod

  enable_private_endpoints = local.is_prod


  enable_private_dns = local.is_prod

  # Networking
  enable_nat_gateway = local.is_prod

  enable_jumpbox_public_ip = !local.is_prod

  # ACR SKU
  acr_sku = local.is_prod ? "Premium" : "Basic"
}
