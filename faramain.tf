terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "FThomas-Pipe" # remplace par ton vrai nom d’organisation Terraform Cloud
    workspaces {
      name = "FaraSpace" # le nom exact de ton workspace Terraform Cloud
    }
  }
}

provider "azurerm" {
  features {}
}

# Exemple : création d’un groupe de ressources
resource "azurerm_resource_group" "rg_demo" {
  name     = "rg-terraform-demo"
  location = "Canada Central"
}
