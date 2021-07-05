# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.1"
    }
  }
}

# crea un service principal y rellena los siguientes datos para autenticar
provider "azurerm" {
  features {}
  subscription_id = "17b8d1eb-a17d-448b-bbd9-0ee611ad3ec0"
  client_id       = "25888a55-02b4-4dd8-9086-ec54aa9d6546"
  client_secret   = "QKU37xsgKZW1fYotTCKiwv_eaRmRoWNhHz"
  tenant_id       = "899789dc-202f-44b4-8472-a6d40f9eb440"
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group

resource "azurerm_resource_group" "rg" {
    name     =  "kubernetes_rg"
    location = var.location

    tags = {
        environment = "CP2"
    }

}

# Storage account
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account

resource "azurerm_storage_account" "stAccount" {
    name                     = var.storage_account
    resource_group_name      = azurerm_resource_group.rg.name
    location                 = azurerm_resource_group.rg.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "CP2"
    }

}

# Creamos un disco en master para usarlo en el nfs
resource "azurerm_managed_disk" "nfs" {
  count                = length(var.workers) > 0 ? 1 : 0

  name                 = "${azurerm_virtual_machine.vm_k8s_node["Node01"].name}-data"
  location             = azurerm_resource_group.rg_k8s.location
  resource_group_name  = azurerm_resource_group.rg_k8s.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}



