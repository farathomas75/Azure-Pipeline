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
