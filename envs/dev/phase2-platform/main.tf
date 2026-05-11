module "core_infra" {
  source = "../../../modules/core-infra"

  prefix      = "platform"
  location    = var.location
  environment = "dev"
  tags        = var.tags

  enable_firewall          = false
  enable_nat_gateway       = false
  enable_acr               = true
  enable_private_endpoints = false
  acr_sku                  = "Basic"

}