resourcegroup1 = {
    rg12 = "west europe"
    rg23 = "west europe"
}
/*
RG =[{
  location = "east us"
  resourcegroup = "RG456"
}]*/


  RG = {
    RG3 = "north europe"
    RG2 ="west europe"
  }

virtual_network = {
    spoke_vnet = {
        name = "kausarvnet"
        name1 = "kausarvnet1"
        address_space = ["10.0.0.0/16"]
        address_space_all = ["10.1.0.0/16", "10.2.0.0/16", "10.3.0.0/16" ]
    }
}
/*
  MYRG_kau = {
    name = 12
    location = "west europe"
  }*/
  # o
MYRG_kau = [12,"west europe"]


env = ["test","dev","stag","prod"]