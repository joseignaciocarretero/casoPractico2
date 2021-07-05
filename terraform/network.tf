# Creación de red
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_virtual_network" "myNet" {
    name                = "kubernetesnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "CP2"
    }
}

# Creación de subnet
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

resource "azurerm_subnet" "mySubnet" {
    name                   = "terraformsubnet"
    resource_group_name    = azurerm_resource_group.rg.name
    virtual_network_name   = azurerm_virtual_network.myNet.name
    address_prefixes       = ["10.0.1.0/24"]

}

# Create NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

resource "azurerm_network_interface" "myNic" {
  count               = length(var.vms)
  name                = "nic-${var.vms[count.index]}"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "ipconf-${var.vms[count.index]}"
    subnet_id                      = azurerm_subnet.mySubnet.id 
    #se podría usar en el allocation "Dynamic" para no poner una ip fija y fuera por dhcp
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.${count.index +10}"
    public_ip_address_id           = azurerm_public_ip.myPublicIp[count.index].id
  }

    tags = {
        environment = "CP2"
    }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "myPublicIp" {
  count               = length(var.vms)
  name                = "vmip${var.vms[count.index]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.vms[count.index]}"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}

# Create NIC para Master
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

resource "azurerm_network_interface" "myNicMaster" {
    name                = "nic-Master"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "ipconf-Master"
    subnet_id                      = azurerm_subnet.mySubnet.id 
    #se podría usar en el allocation "Dynamic" para no poner una ip fija y fuera por dhcp
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.50"
    public_ip_address_id           = azurerm_public_ip.myPublicIpMaster.id
  }

    tags = {
        environment = "CP2"
    }

}

# IP pública para Master
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "myPublicIpMaster" {
  name                = "vmipMaster"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.vmsmaster}"
  sku                 = "Basic"

    tags = {
        environment = "CP2"
    }

}

