module "core_infra" {
  source = "../../../modules/core-infra"

  prefix      = "platform"
  location    = var.location
  environment = "prod"
  tags        = var.tags

  enable_firewall          = false
  enable_nat_gateway       = true
  enable_acr               = true
  enable_private_endpoints = true
  acr_sku                  = "Premium"

}