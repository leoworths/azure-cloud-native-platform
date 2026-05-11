variable "environment" {
  type        = string
  description = "Deployment environment (dev or prod)"
  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either 'dev' or 'prod'."
  }
}

variable "location" {
  type        = string
  description = "Azure region for resource creation"
}

variable "prefix" {
  type        = string
  description = "Resource prefix for naming convention"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
}

variable "allowed_locations" {
  type        = list(string)
  description = "Allowed Azure regions"
}


# variable "prod_subscription_id" {
#   type        = string
#   description = "Subscription ID for the production environment"
# }
# variable "dev_subscription_id" {
#   type        = string
#   description = "Subscription ID for the development environment"
# }
