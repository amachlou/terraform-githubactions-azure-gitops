terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = "westeurope"
  name     = "gitops-ress-grp-${random_string.resource_code.result}"
}

# *******************************************

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

# resource "azurerm_resource_group" "tfstate" {
#   name     = "tfstate"
#   location = "westeurope"
# }

backend "azurerm" {
      resource_group_name  = azurerm_resource_group.rg.name
      storage_account_name = azurerm_storage_account.tfstate.name
      container_name       = azurerm_storage_container.tfstate.name
      key                  = "terraform.tfstate"
  }

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstate-storage-account-${random_string.resource_code.result}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = "DEV"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate-storage-container-${random_string.resource_code.result}"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}
