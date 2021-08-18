# AWS Provider
provider "aws" {
  region = var.awsRegion
}

# Google Provider
provider "google" {
  project = var.projectPrefix
  region  = var.googleRegion
  zone    = var.googleZone
}