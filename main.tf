terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.89.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "azurerm" {
features {}
}


resource "random_string" "kau" {
  length           = 16
  special          = false
  upper = false
}


resource "azurerm_resource_group" "MYRG"{
    for_each = var.resourcegroup1
    name = "${var.kausar}-${each.key}"
    location = var.location #each.value
}

resource "azurerm_resource_group" "MYRG1"{
    name = local.RGname
    #location = var.RG["location1"] # or location = var.RG.location1
    location =lookup(var.RG,var.resourcegroup)
    tags = local.common_tags
}
/*
resource "azurerm_resource_group" "MYRG_kau"{
    name = var.MYRG_kau.name
    #location = var.RG["location1"] # or location = var.RG.location1
    location =var.MYRG_kau.location
}
*/
#or
resource "azurerm_resource_group" "MYRG_kau"{
    #name = var.MYRG_kau[0]
    name = terraform.workspace
    #location = var.RG["location1"] # or location = var.RG.location1
    location =var.MYRG_kau[1]
}


resource "azurerm_resource_group" "env" {
for_each=var.env
name = "kausar2-${each.key}"
location = var.location

}

resource "azurerm_storage_account" "kaust" {
  for_each = var.env
  name                     = "kaus${each.key}${random_string.kau.id}"
  resource_group_name      = azurerm_resource_group.env[each.key].name
  location                 = azurerm_resource_group.env[each.key].location
  account_tier             = "Standard"
  account_replication_type = "LRS"
#count =2
  tags = {
    environment = each.key
  }
  }


  resource "azurerm_virtual_network" "spoke_vnet" {
  name                = local.vnet #or var.virtual_network.spoke_vnet.name
  #address_space       = var.virtual_network.spoke_vnet.address_space
  address_space = local.vnet_address_space
  location            = azurerm_resource_group.MYRG1.location
  resource_group_name = azurerm_resource_group.MYRG1.name
  tags                = local.common_tags
}


  resource "azurerm_virtual_network" "spoke_vnet1" {

    count = var.resourcegroup == "RG2" ? 1 : 2
  name                = local.vnet #or var.virtual_network.spoke_vnet.name
  #address_space       = var.virtual_network.spoke_vnet.address_space
  address_space = local.vnet_address_space
  location            = azurerm_resource_group.MYRG1.location
  resource_group_name = azurerm_resource_group.MYRG1.name
  tags                = local.common_tags
}


# Output - For Loop One Input and List Output with rgname Name 
output "kausar_storage" {
  value = [for rgname in azurerm_resource_group.env: rgname.name ]  
}

# Output - For Loop Two Inputs, List Output which is Iterator i (var.environment)
output "kausar_rg" {
  value = [for env,rgname in azurerm_resource_group.env: env ]  
}


# Output - For Loop One Input and Map Output with VNET ID and VNET Name
output "kausar_rg1" {
  
  value = {for rgname in azurerm_resource_group.env: rgname.id => rgname.name }
}
/* This is the ouput from above two three commands
kausar_rg = [
  "dev",
  "prod",
  "stag",
  "test",
]
  "/subscriptions/225f0ca3-77d4-4da8-bd04-4e3bfb2a430e/resourceGroups/kausar2-dev" = "kausar2-dev"
  "/subscriptions/225f0ca3-77d4-4da8-bd04-4e3bfb2a430e/resourceGroups/kausar2-prod" = "kausar2-prod"
  "/subscriptions/225f0ca3-77d4-4da8-bd04-4e3bfb2a430e/resourceGroups/kausar2-stag" = "kausar2-stag"
  "/subscriptions/225f0ca3-77d4-4da8-bd04-4e3bfb2a430e/resourceGroups/kausar2-test" = "kausar2-test"
}
*/

# Output - For Loop Two Inputs and Map Output with Iterator env and VNET Name
output "kausar_rg2" {
  
  value = {for env,rgname in azurerm_resource_group.env: env => rgname.name }
}

# Terraform keys() function: keys takes a map and returns a list containing the keys from that map.
output "kausar_rg2_functions" {
  
  value = keys({for env,rgname in azurerm_resource_group.env: env => rgname.name })
}

# Terraform values() function: values takes a map and returns a list containing the values of the elements in that map.
output "kausar_rg2_values" {
  
  value = values({for env,rgname in azurerm_resource_group.env: env => rgname.name })
}
