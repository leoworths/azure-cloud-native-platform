
variable "prefix" {
  type        = string
  description = "Resource name prefix"
  default     = "platform"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  # default = {
  #   owner      = "platform-team"
  #   cost_center = "platform"
  # }
}

variable "environment" {
  type        = string
  description = "Deployment environment (dev/prod)"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either 'dev' or 'prod'."
  }
}

variable "enable_firewall" {
  type        = bool
  description = "Enable Azure Firewall"
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Enable NAT Gateway"
}

variable "enable_acr" {
  type        = bool
  description = "Enable Azure Container Registry"
}

variable "enable_private_endpoints" {
  type        = bool
  description = "Enable Private Endpoints for resources"
}
variable "enable_jumpbox_public_ip" {
  type        = bool
  description = "Enable Public IP for Jumpbox"
}
variable "enable_bastion" {
  type        = bool
  description = "Enable Bastion Host"
}
variable "acr_sku" {
  type        = string
  description = "SKU for Azure Container Registry (e.g., Basic, Standard, Premium)"
}
variable "ssh_public_key" {
  description = "The path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
}
# ------------------------------------------
# Locals for dynamic tags (to use in resources)
# ------------------------------------------
locals {
  common_tags = merge(
    var.tags,
    {
      Env = var.environment
    }
  )
}

# variable "azure_devops_project_name" {
#   description = "Azure DevOps project name"
#   type        = string
#   default    = "zero-trust"

# }

# variable "azure_devops_organization_url" {
#   description = "Azure DevOps organization URL"
#   type        = string
#   default     = "https://dev.azure.com/cetera-org"
# }



# // Object IDs from Phase 1
# variable "platform_admins_object_id" {
#   type        = string
# }
# variable "platform_operators_object_id" {
#   type        = string
# }
# variable "platform_developers_object_id" {
#   type        = string
# }
# variable "platform_readers_object_id" {
#   type        = string
# }

# locals {
#   is_prod = var.environment == "prod"
#   enable_bastion             = local.is_prod
#   enable_firewall            = local.is_prod
#   enable_private_endpoints   = local.is_prod
#   enable_jumpbox_public_ip   = !local.is_prod
# }