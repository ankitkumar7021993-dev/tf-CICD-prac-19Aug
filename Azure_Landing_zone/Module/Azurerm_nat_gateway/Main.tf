data "azurerm_client_config" "current" {}

resource "azurerm_nat_gateway" "nat" {
  for_each            = var.natgws
  name                = each.value.natgw_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  sku_name            = each.value.sku_name
}

resource "azurerm_nat_gateway_public_ip_association" "nat_pip" {
  for_each            = var.natgws
  nat_gateway_id      = azurerm_nat_gateway.nat[each.key].id
  public_ip_address_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.rg_name}/providers/Microsoft.Network/publicIPAddresses/${each.value.pip_name}"
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat" {
  for_each = {
    for assoc in flatten([
      for key, nat in var.natgws : [
        for subnet in nat.subnet_names : {
          nat_key       = key
          subnet_name   = subnet.subnet_name
          vnet_name     = subnet.vnet_name
          rg_name       = nat.rg_name
        }
      ]
    ]) : "${assoc.nat_key}_${assoc.subnet_name}" => assoc
  }

  subnet_id      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.rg_name}/providers/Microsoft.Network/virtualNetworks/${each.value.vnet_name}/subnets/${each.value.subnet_name}"
  nat_gateway_id = azurerm_nat_gateway.nat[each.value.nat_key].id
}
