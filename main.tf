terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "FThomas-Pipe"   # Organisation dans Terraform Cloud
    workspaces {
      name = "FaraSpace"            # Workspace dans Terraform Cloud
    }
  }
}

provider "azurerm" {
  features {}
}

#1. Resource Group
resource "azurerm_resource_group" "rg_demo" {
  name     = "rg-terraform-demo"
  location = "eastus"
}

