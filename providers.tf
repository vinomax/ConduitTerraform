terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = "~>1.0.0"
    }
  }
}

provider "azurerm" {
  features {}  
}
provider "azapi" {}
provider "azurerm" {
  alias                      = "Conduit"
  subscription_id            = var.subscription_id
  skip_provider_registration = true
  features {}
}
