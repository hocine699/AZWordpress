#IaC on Azure Cloud Platform | Declare Azure as the Provider
# Configure the Microsoft Azure Provider
terraform {
required_providers {
azurerm = {
source = "hashicorp/azurerm"
version = "~>2.0"
}
}
}

provider "azurerm" {
features {}

subscription_id = "393e3de3-0900-4b72-8f1b-fb3b1d6b97f1"
tenant_id = "7349d3b2-951f-41be-877e-d8ccd9f3e73c"
client_id = "144b8605-b50a-4006-9e0d-2be66549f401"
client_secret = "Poh8Q~~.8Bs6xDelqmtmIPS5vOUSAlNO5SjPDcT~"
}

##Resource Group
resource "azurerm_resource_group" "rg" {
name = "TF-Jenkins-Hocine"
location = "france central"
}

##Avaibility Set
resource "azurerm_availability_set" "DemoAset" {
name = "tf-aset"
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
}

##Virtual Network
resource "azurerm_virtual_network" "vnet" {
name = "tf-vNet"
address_space = ["10.0.0.0/16"]
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name
}

##Subnet
resource "azurerm_subnet" "subnet" {
name = "Internal"
resource_group_name = azurerm_resource_group.rg.name
virtual_network_name = azurerm_virtual_network.vnet.name
address_prefixes = ["10.0.2.0/24"]
}

##Network interface
resource "azurerm_network_interface" "example" {
name = "tf-vmwin-nic"
location = azurerm_resource_group.rg.location
resource_group_name = azurerm_resource_group.rg.name

ip_configuration {
name = "internal"
subnet_id = azurerm_subnet.subnet.id
private_ip_address_allocation = "Dynamic"
}
}

##Azure Virtual Machine
resource "azurerm_windows_virtual_machine" "example" {
name = "VM-TF-Hocine"
resource_group_name = azurerm_resource_group.rg.name
location = azurerm_resource_group.rg.location
size = "Standard_F2"
admin_username = "hocine"
admin_password = "P@ssword1234!"
availability_set_id = azurerm_availability_set.DemoAset.id
network_interface_ids = [
azurerm_network_interface.example.id,
]

os_disk {
caching = "ReadWrite"
storage_account_type = "Standard_LRS"
}

source_image_reference {
publisher = "MicrosoftWindowsServer"
offer = "WindowsServer"
sku = "2022-Datacenter"
version = "latest"
}
}
