data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "3tierstorageaccts"
    container_name       = "tfstate"
    key                  = "phase2-dev-core-infra.tfstate"
  }
}


data "terraform_remote_state" "aks" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "3tierstorageaccts"
    container_name       = "tfstate"
    key                  = "phase3-dev-aks-infra.tfstate"
  }
}

data "azurerm_resource_group" "platform" {
  name = data.terraform_remote_state.platform.outputs.platform_rg_name
}
