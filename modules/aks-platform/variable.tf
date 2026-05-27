variable "environment" { 
  type = string 
  }
variable "prefix" { 
  type = string 
  }
variable "location" { 
  type = string 
  }
variable "tags" { 
  type = map(string) 
  }
variable "enable_firewall" { 
  type = bool 
  }
variable "enable_nat_gateway" { 
  type = bool 
  }
variable "enable_postgres" { 
  type = bool 
  }
variable "enable_private_dns" { 
  type = bool 
  }
variable "enable_private_aks" { 
  type = bool 
  }

# FROM REMOTE STATE (NOW PASSED IN)
variable "platform_rg_name" {}
variable "platform_rg_location" {}

variable "spoke_rg_name" {}
variable "spoke_rg_location" {}

variable "dns_rg_name" {}
variable "spoke_vnet_id" {}

variable "aks_subnet_id" {}
variable "postgres_subnet_id" {}

variable "firewall_private_ip" {}

variable "log_analytics_workspace_id" {}
variable "acr_id" {}
variable "keyvault_id" {}

variable "platform_admins_object_id" {}


