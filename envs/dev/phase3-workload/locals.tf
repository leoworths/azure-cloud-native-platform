locals {

  # -----------------------------------
  # Environment Detection
  # -----------------------------------
  is_prod = var.environment == "prod"

  # -----------------------------------
  # Networking
  # -----------------------------------
  enable_firewall    = false
  enable_nat_gateway = false

  # -----------------------------------
  # AKS
  # -----------------------------------
  enable_private_aks = false
  enable_private_dns = false

  # -----------------------------------
  # Database
  # -----------------------------------
  enable_postgres = true
}