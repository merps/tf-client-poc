# Google Provider
provider "google" {
  project = var.projectPrefix
  region  = var.gcpRegion
  zone    = var.gcpZone
}