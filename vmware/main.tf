# The Data sections are about determining where the virtual machine will be placed.
# Here we are naming the vSphere DC, the cluster, datastore, virtual network and the template
# name. These are called upon later when provisioning the VM resource
/*
data "vsphere_datacenter" "dc" {
  name = var.vsphere.datacenter
}

data "vsphere_host" "host" {
  name          = var.vsphere.host
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vm_guest.datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere.cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vm_guest.network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template.name
  datacenter_id = data.vsphere_datacenter.dc.id
}
*/
data "template_file" "init" {
  template = file("${path.module}/files/lab_do.do.json")
  vars = {
    bigip_hostname = var.bigip.hostname,
    bigip_user = var.bigip.username
    bigip_pass = var.bigip.password
    dns = var.dns
    search_order = var.search_order
    biqiq_user = var.bigiq_user
    bigiq_pass = var.bigiq_pass
    license_pool = var.license_pool
  }
}
resource "bigip_do" "do-example" {
  do_json = file("files/lab_do.json")
  timeout = 15
}