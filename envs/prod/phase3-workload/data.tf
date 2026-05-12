data "terraform_remote_state" "platform" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "3tierstorageaccts"
    container_name       = "tfstate"
    key                  = "phase2-prod-core-infra.tfstate"
  }
}
