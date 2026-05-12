environment = "prod"
location    = "eastus2"
prefix      = "platform"
tags = {
  Env        = "var.environment"
  Owner      = "platform-team"
  CostCenter = "shared"
}
allowed_locations = ["eastus", "westeurope", "canadacentral", "eastus2"]