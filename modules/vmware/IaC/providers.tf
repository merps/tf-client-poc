# The Provider block sets up the BIG-IP provider - How to connect directly to the
# BIG_IP Instances

provider "bigip" {
  address  = var.bigip.hostname
  username = var.bigip.username
  password = var.bigip.password
}

# The Provider block sets up the vSphere provider - How to connect to vCenter. Note the use of
# variables to avoid hardcoding credentials here
/*
provider "vsphere" {
  user                 = var.vsphere.user
  password             = var.vsphere.password
  vsphere_server       = var.vsphere.server
  allow_unverified_ssl = true
}*/