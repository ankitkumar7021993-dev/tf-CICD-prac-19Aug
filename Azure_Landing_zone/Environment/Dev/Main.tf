module "for_rg" {
  rgs    = var.rgs
  source = "../../Module/Azurerm_rg"
}

module "for_vnet" {
  vnets      = var.vnets
  source     = "../../Module/Azurerm_vnet"
  depends_on = [module.for_rg]
}

module "for_subnet" {
  subnets    = var.subnets
  source     = "../../Module/Azurerm_subnet"
  depends_on = [module.for_vnet]
}

module "for_vm" {
  vms        = var.vms
  source     = "../../Module/Azurerm_vm"
  depends_on = [module.for_rg, module.for_subnet]
}

module "for_nsg" {
  nsgs       = var.nsgs
  source     = "../../Module/NSG"
  depends_on = [module.for_rg]
}

module "for_pip" {
  pips       = var.pips
  source     = "../../Module/Azurerm_public_ip"
  depends_on = [module.for_rg]
}

#module "for_appgw" {
#appgws     = var.appgws
#source     = "../../Module/Azurerm_app_gateway"
#depends_on = [module.for_subnet, module.for_pip]
#}

module "for_natgw" {
  natgws     = var.natgws
  source     = "../../Module/Azurerm_nat_gateway"
  depends_on = [module.for_subnet, module.for_pip]
}

module "for_bastion" {
  bastions   = var.bastions
  source     = "../../Module/Azurerm_bastion"
  depends_on = [module.for_subnet, module.for_pip]
}