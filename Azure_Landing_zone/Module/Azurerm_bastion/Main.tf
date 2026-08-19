data "azurerm_client_config" "current" {}

resource "azurerm_bastion_host" "bastion" {
  for_each            = var.bastions
  name                = each.value.bastion_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  sku                 = each.value.sku

  ip_configuration {
    name                 = "configuration"
    subnet_id            = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.rg_name}/providers/Microsoft.Network/virtualNetworks/${each.value.vnet_name}/subnets/AzureBastionSubnet"
    public_ip_address_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.rg_name}/providers/Microsoft.Network/publicIPAddresses/${each.value.pip_name}"
  }
}
