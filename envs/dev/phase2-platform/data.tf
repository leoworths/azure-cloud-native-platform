data "terraform_remote_state" "identity" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "3tierstorageaccts"
    container_name       = "tfstate"
    key                  = "phase1-dev.tfstate"
  }
}




