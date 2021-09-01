## Object Map for definition of BIG-IP connection information
variable "bigip" {
  description = "BIG-IP Connection Information"
  type = object({
    hostname = string
    username = string
    password = string
  })
}
variable "dns" {
  type = string
}
variable "search_order" {
  type = list(string)
}
variable "bigiq_ip" {
  type = string
}
variable "bigiq_user" {
  type = string
}
variable "bigiq_pass" {
  type = string
}
variable "license_pool" {
  type = string
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