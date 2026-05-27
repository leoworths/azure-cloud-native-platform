module "core_infra" {
  source = "../../../modules/core-infra"

  prefix      = var.prefix
  location    = var.location
  environment = var.environment
  tags        = var.tags

  enable_firewall          = local.enable_firewall
  enable_nat_gateway       = local.enable_nat_gateway
  enable_acr               = true
  enable_private_endpoints = local.enable_private_endpoints
  enable_jumpbox_public_ip = local.enable_jumpbox_public_ip
  enable_bastion           = local.enable_bastion
  acr_sku                  = local.acr_sku

}



# module "core_infra" {
#   source = "../../../modules/core-infra"

#   prefix      = "platform"
#   location    = var.location
#   environment = "dev"
#   tags        = var.tags

#   enable_firewall          = false
#   enable_nat_gateway       = false
#   enable_acr               = true
#   enable_private_endpoints = false
#   enable_jumpbox_public_ip = true
#   enable_bastion           = false
#   acr_sku                  = "Basic"

# }