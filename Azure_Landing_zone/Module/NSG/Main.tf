resource "azurerm_network_security_group" "nsg" {
  for_each            = var.nsgs
  name                = "my-nsg"
  location            = each.value.location
  resource_group_name = each.value.rg_name

  security_rule {
    name                       = "AllowAll"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
}