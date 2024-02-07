variable "resourcegroup1" {
    description = "resourceRG"
  type = map
}

variable "resourcegroup" {
    description = "resourceRG"
  type = string
  default = "west europe"
}



locals {
    RGname = "kausar2-${var.resourcegroup}"
    environment = "prod"
    vnet = "kausar-vnet"
    #vnet_address_space = (var.resourcegroup == "RG2" ? var.virtual_network.spoke_vnet.address_space : var.virtual_network.spoke_vnet.address_space_all)
    vnet_address_space = (var.resourcegroup != "RG2" ? var.virtual_network.spoke_vnet.address_space : var.virtual_network.spoke_vnet.address_space_all)
    name = "kausar"
    name1 = "torm"
    common_tags = {
       environment = local.environment
       name = local.name
       name1 = local.name1
    }
}




variable "location" {
  description ="location"
  type = string
  default = "north europe"
  validation {
    #condition = var.location == "north europe"|| var.location =="eastus2"--or use below both are same
    condition = contains(["north europe","east us2"],var.location)
    error_message = "We only north europe and east us2."
  }
}

variable "kausar" {
description = "default"
type = string
default = "kau"

}
/*
variable "RG" {
    type = list(object({
      resourcegroup = string
      location = string 
    }))
}*/

variable "RG" {
  type = map
  default = {
    location = "east us2"
    location1 ="north europe"
  }
  
}

variable "virtual_network" {
    type = map
}

/*
variable "MYRG_kau" {
  description = "Azure MySQL DB Threat Detection Policy"
  type = object({
    name = number,
    location = string
  })
}
*/
# or
variable "MYRG_kau" {
  description = "Azure MySQL DB Threat Detection Policy"
  type = tuple([number,string])
}

variable "env" {
    type = set(string)
}