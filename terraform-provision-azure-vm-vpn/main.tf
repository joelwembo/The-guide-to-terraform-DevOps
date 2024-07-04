
# Azure VM provisionning using terraform
# create resource group first
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resourcegroup}"
  location = "${var.location}"
}


#primary azure virtual network
resource "azurerm_virtual_network" "prodxcloud-network" {
  name                = "prodxcloud-network"
  address_space       = ["10.0.0.0/22"]
  location            = var.location
  resource_group_name = var.resourcegroup
  depends_on = [ azurerm_resource_group.resource_group ]
}

# Second Virtual Network VPN-VN
# resource "azurerm_virtual_network" "VPN-VN" {
#   name                = "VPN-VN"
#   address_space       = ["172.16.0.0/16"]
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name
# }

resource "azurerm_subnet" "prodxcloud-internal-subnet" {
  name                 = "prodxcloud-internal-subnet"
  resource_group_name  = var.resourcegroup
  virtual_network_name = azurerm_virtual_network.prodxcloud-network.name
  address_prefixes     = ["10.0.2.0/24"]
}
 # Second subnet with attached address prefixed to VPN-Virtual network
# resource "azurerm_subnet" "prodxcloud-vpn-network-subnet" {
#   name                 = "prodxcloud-vpn-network-subnet"
#   resource_group_name  = var.resourcegroup
#   virtual_network_name = azurerm_virtual_network.VPN-VN.name
#   address_prefixes     = ["172.16.1.0/24"]
# }

resource "azurerm_public_ip" "prodxcloud-public-ip-7" {
  name                = "prodxcloud-public-ip-7"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  allocation_method   = "Dynamic"
}


resource "azurerm_network_security_group" "prodxcloud-sg-1" {
  name                = "prodxcloud-sg-1"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_https"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# VPN Azure vpn gateway public ip
# resource "azurerm_public_ip" "vpn_gateway_public_ip" {
#   name                = "vpn_gateway_public_ip"
#   location            = azurerm_resource_group.resource_group.location
#   resource_group_name = azurerm_resource_group.resource_group.name
#   allocation_method   = "Dynamic"  # or "Static" depending on your requirement
# }

# # VPN Azure Virtual network Gateway
# resource "azurerm_virtual_network_gateway" "VPN-VNG" {
#   name                = "VPN-VNG"
#   resource_group_name = azurerm_resource_group.resource_group.name
#   location            = azurerm_resource_group.resource_group.location
#   type                = "Vpn"
#   vpn_type            = "RouteBased"
#   sku                 = "VpnGw1"

#   ip_configuration {
#     name      = "gwconfig1"
#     subnet_id =  azurerm_subnet.prodxcloud-vpn-network-subnet.id
#     public_ip_address_id = azurerm_public_ip.vpn_gateway_public_ip.id
#   }

#    vpn_client_configuration {
#     address_space = ["172.16.0.0/27"]
#     }

#     bgp_settings {
#       asn = 65515
#     }

#  depends_on = [ azurerm_subnet.prodxcloud-vpn-network-subnet ]

# }


# azure network interface
resource "azurerm_network_interface" "prodxcloud-nic" {
  name                = "prodxcloud-nic"
  resource_group_name = var.resourcegroup
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.prodxcloud-internal-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.prodxcloud-public-ip-7.id
  }
}

resource "tls_private_key" "prodxcloud-azure-private-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "azurerm_linux_virtual_machine" "prodxcloud-azure-lab-7" {
  name                            = "prodxcloud-lab-7"
  resource_group_name             = var.resourcegroup
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.prodxcloud-nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("${path.module}/id_rsa.pub")
  }

 source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
 }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  depends_on = [ azurerm_resource_group.resource_group ]

  tags = {
    environment = "prodxcloud VM ubuntu Lab 7"
  }

}

output "AzureVMDetails" {

  value = [azurerm_linux_virtual_machine.prodxcloud-azure-lab-7.public_ip_addresses, azurerm_linux_virtual_machine.prodxcloud-azure-lab-7 ]
  sensitive = true
  
}

output "tls_private_key" {
  value     = tls_private_key.prodxcloud-azure-private-key.private_key_pem
  sensitive = true
}


