# Management Groups
output "platform_mg_id" {
  value = module.landingzone.platform_mg_id
}

output "workloads_mg_id" {
  value = module.landingzone.workloads_mg_id
}

output "dev_mg_id" {
  value = module.landingzone.dev_mg_id
}

output "staging_mg_id" {
  value = module.landingzone.staging_mg_id
}

output "prod_mg_id" {
  value = module.landingzone.prod_mg_id
}

# Azure AD Groups
output "platform_admins_object_id" {
  value = module.landingzone.platform_admins_object_id
}

output "platform_operators_object_id" {
  value = module.landingzone.platform_operators_object_id
}

output "platform_developers_object_id" {
  value = module.landingzone.platform_developers_object_id
}

output "platform_readers_object_id" {
  value = module.landingzone.platform_readers_object_id
}