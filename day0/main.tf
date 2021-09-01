# Provision Network Security accounts across CSP for purpose of demostration
module "aws_iac" {
  source = "../modules/aws/IaC"
}

module "google_iac" {
  source = "../modules/gcp/IaC"
}

module "azure_iac" {
  source = "../modules/azure/IaC"
}