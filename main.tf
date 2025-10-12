terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "FThomas-Pipe"   # Remplace par ton organisation Terraform Cloud
    workspaces {
      name = "FaraSpace"            # Remplace par ton workspace Terraform Cloud
    }
  }
}

provider "azurerm" {
  features {}
}

#1. Resource Group (deja present)
resource "azurerm_resource_group" "rg_demo" {
  name     = "rg-terraform-demo"
  location = "EAST US"
}

#2. Virtual Network
resource "azurerm_virtual_network" "vnet_demo" {
  name                = "vnet-demo"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_demo.location
  resource_group_name = azurerm_resource_group.rg_demo.name
}

#3. Subnet
resource "azurerm_subnet" "subnet_demo" {
  name                 = "subnet-demo"
  resource_group_name  = azurerm_resource_group.rg_demo.name
  virtual_network_name = azurerm_virtual_network.vnet_demo.name
  address_prefixes     = ["10.0.1.0/24"]
}

