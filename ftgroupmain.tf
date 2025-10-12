terraform {
  cloud {
    organization = "FThomas-Pipe"
    workspaces {
      name = "FaraSpace"
    }
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_demo" {
  name     = "rg-terraform-demo"
  location = "East US"
}
