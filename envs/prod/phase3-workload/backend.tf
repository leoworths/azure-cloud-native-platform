terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "3tierstorageaccts"
    container_name       = "tfstate"
    key                  = "phase3-prod-aks-infra.tfstate"
  }
}


