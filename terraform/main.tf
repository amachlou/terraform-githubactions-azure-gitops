terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.110.0"
    }
  }
}
  
provider "azurerm" {
 features {}
}

resource "azurerm_resource_group" "rg" {
  location = "westeurope"
  name     = "gitops-ress-grp"
}