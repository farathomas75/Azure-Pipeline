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

#4. Network Interface (reliee au subnet existant)
resource "azurerm_network_interface" "nic_demo" {
  name                = "nic-demo"
  location            = azurerm_resource_group.rg_demo.location
  resource_group_name = azurerm_resource_group.rg_demo.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_demo.id
    private_ip_address_allocation = "Dynamic"
  }
}

#5.a. Machine Virtuelle (Ubuntu Linux)
resource "azurerm_linux_virtual_machine" "fthomas_vm_demo" {
  name                = "fthomas-vm"
  resource_group_name = azurerm_resource_group.rg_demo.name
  location            = azurerm_resource_group.rg_demo.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_demo.id
  ]

  admin_password = "Infected123!"  #A changer avant le deploiement(minimum 12 caractères)
  disable_password_authentication = false  #autorise le mot de passe

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

}

#6. # Deploiement du conteneur sur Azure Container Instances
resource "azurerm_container_group" "nginx_demo" {
  name                = "fthomas-nginx-container-${random_string.suffix.result}"
  location            = azurerm_resource_group.rg_demo.location
  resource_group_name = azurerm_resource_group.rg_demo.name
  os_type             = "Linux"

  container {
    name   = "nginx"
    image  = "mcr.microsoft.com/azuredocs/aci-helloworld:latest"  # Image publique fiable
    cpu    = 1
    memory = 1.5

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "fthomas-nginx-${random_string.suffix.result}"
}

# Génération d’un suffixe aléatoire pour le nom DNS
resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}
