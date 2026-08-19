data "azurerm_client_config" "current" {}

resource "azurerm_application_gateway" "network" {
  for_each            = var.appgws
  name                = each.value.appgw_name
  resource_group_name = each.value.rg_name
  location            = each.value.location

  sku {
    name     = each.value.sku_name
    tier     = each.value.sku_tier
    capacity = each.value.capacity
  }
  waf_configuration {
    enabled          = true
    firewall_mode    = "Prevention"
    rule_set_type    = "OWASP"
    rule_set_version = "3.2"
  }

  gateway_ip_configuration {
    name      = "my-gateway-ip-configuration"
    subnet_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.rg_name}/providers/Microsoft.Network/virtualNetworks/${each.value.vnet_name}/subnets/${each.value.subnet_name}"
  }

  frontend_port {
    name = "frontendPort"
    port = 80
  }

  frontend_ip_configuration {
    name                 = "frontendIP"
    public_ip_address_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${each.value.rg_name}/providers/Microsoft.Network/publicIPAddresses/${each.value.pip_name}"
  }

  backend_address_pool {
    name = "backendAddressPool"
  }

  backend_http_settings {
    name                  = "backendHttpSettings"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  http_listener {
    name                           = "httpListener"
    frontend_ip_configuration_name = "frontendIP"
    frontend_port_name             = "frontendPort"
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = "requestRoutingRule"
    rule_type                  = "Basic"
    http_listener_name         = "httpListener"
    backend_address_pool_name  = "backendAddressPool"
    backend_http_settings_name = "backendHttpSettings"
    priority                   = 100
  }
}
