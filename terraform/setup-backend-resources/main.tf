terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

#   backend "local" {
#     path = "terraform.tfstate"
#  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name+"-${random_string.random-string.result}"
}

resource "random_string" "random-string" {
  length = 4
  lower  = true
}
# ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 

resource "azurerm_storage_account" "tfstate-storage-account" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false

  tags = {
    environment = "DEV"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.tfstate-storage-account.name
  container_access_type = "private"
}
