terraform {
  required_providers {
    bigip = {
      source  = "F5Networks/bigip"
      version = "1.11.0"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.0.2"
    }
  }
}