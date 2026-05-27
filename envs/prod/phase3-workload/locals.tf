locals {

  # -----------------------------------
  # Environment Detection
  # -----------------------------------
  is_prod = var.environment == "prod"

  # -----------------------------------
  # Networking
  # -----------------------------------
  enable_firewall    = false
  enable_nat_gateway = true

  # -----------------------------------
  # AKS
  # -----------------------------------
  enable_private_aks = true
  enable_private_dns = true

  # -----------------------------------
  # Database
  # -----------------------------------
  enable_postgres = true
}