## Object Map for definition of BIG-IP connection information
variable "bigip" {
  description = "BIG-IP Connection Information"
  type = object({
    hostname   = string
    username   = string
    password   = string
  })
}
/*
## Object Map for definition of vsphere
variable "vsphere" {
  description = "vSphere Connection Information"
  type = object({
    server     = string
    user       = string
    password   = string
    cluster    = string
    datacenter = string
    host       = string
  })
}
*/