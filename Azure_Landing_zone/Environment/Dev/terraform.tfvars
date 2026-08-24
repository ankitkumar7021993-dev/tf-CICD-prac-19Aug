rgs = {
  rg1 = {
    rg_name  = "dev-rg"
    location = "eastus"
  }
  rg2 = {
    rg_name  = "dev-rg1"
    location = "eastus"
  }
  rg3 = {
    rg_name  = "dev-rg2"
    location = "eastus"
  }
}

vnets = {
  vnet1 = {
    vnet_name     = "spoke-vnet"
    rg_name       = "dev-rg"
    location      = "eastus"
    address_space = ["10.0.0.0/16"]
  }
  vnet2 = {
    vnet_name     = "Hub-vnet"
    rg_name       = "dev-rg"
    location      = "eastus"
    address_space = ["10.1.0.0/16"]
} }

subnets = {
  subnet1 = {
    subnet_name      = "app-subnet1"
    rg_name          = "dev-rg"
    vnet_name        = "spoke-vnet"
    address_prefixes = ["10.0.0.0/24"]
  }
  subnet2 = {
    subnet_name      = "app-subnet2"
    rg_name          = "dev-rg"
    vnet_name        = "spoke-vnet"
    address_prefixes = ["10.0.1.0/24"]
  }
  appgw_subnet = {
    subnet_name      = "AppGwSubnet"
    rg_name          = "dev-rg"
    vnet_name        = "spoke-vnet"
    address_prefixes = ["10.0.2.0/24"]
  }
  bastion_subnet = {
    subnet_name      = "AzureBastionSubnet"
    rg_name          = "dev-rg"
    vnet_name        = "spoke-vnet"
    address_prefixes = ["10.0.3.0/26"]
  }
}

vms = {
  vm1 = {
    vm_name                                        = "frontend-vm"
    nic_name                                       = "frontend-nic"
    vnet_name                                      = "spoke-vnet"
    rg_name                                        = "dev-rg"
    location                                       = "eastus"
    subnet_name                                    = "app-subnet1"
    size                                           = "Standard_B2ats_v2"
    admin_username                                 = "adminuser"
    admin_password                                 = "admin@123456789"
    ip_configuration_name                          = "internal"
    ip_configuration_private_ip_address_allocation = "Dynamic"
  }

  vm2 = {
    vm_name                                        = "backend-vm"
    nic_name                                       = "backend-nic"
    vnet_name                                      = "spoke-vnet"
    rg_name                                        = "dev-rg"
    location                                       = "eastus"
    subnet_name                                    = "app-subnet2"
    size                                           = "Standard_B2ats_v2"
    admin_username                                 = "adminuser"
    admin_password                                 = "admin@123456789"
    ip_configuration_name                          = "internal"
    ip_configuration_private_ip_address_allocation = "Dynamic"
  }
}
nsgs = {
  nsg1 = {
    location = "eastus"
    rg_name  = "dev-rg"
  }
}

pips = {
  pip1 = {
    pip_name          = "appgw-pip"
    rg_name           = "dev-rg"
    location          = "eastus"
    allocation_method = "Static"
    sku               = "Standard"
  }
  pip2 = {
    pip_name          = "natgw-pip"
    rg_name           = "dev-rg"
    location          = "eastus"
    allocation_method = "Static"
    sku               = "Standard"
  }
  pip3 = {
    pip_name          = "bastion-pip"
    rg_name           = "dev-rg"
    location          = "eastus"
    allocation_method = "Static"
    sku               = "Standard"
  }
}

appgws = {
  appgw1 = {
    appgw_name  = "dev-appgw"
    rg_name     = "dev-rg"
    location    = "eastus"
    vnet_name   = "spoke-vnet"
    subnet_name = "AppGwSubnet"
    pip_name    = "appgw-pip"
    sku_name    = "WAF_v2"
    sku_tier    = "WAF_v2"
    capacity    = 2
  }
}

natgws = {
  nat1 = {
    natgw_name = "dev-natgw"
    location   = "eastus"
    rg_name    = "dev-rg"
    sku_name   = "Standard"
    pip_name   = "natgw-pip"
    subnet_names = [
      { subnet_name = "app-subnet1", vnet_name = "spoke-vnet" },
      { subnet_name = "app-subnet2", vnet_name = "spoke-vnet" }
    ]
  }
}

bastions = {
  bastion1 = {
    bastion_name = "dev-bastion"
    location     = "eastus"
    rg_name      = "dev-rg"
    vnet_name    = "spoke-vnet"
    pip_name     = "bastion-pip"
    sku          = "Standard"
  }
}