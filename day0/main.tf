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

# Provision single-nic autoscaling instances BIG-IP instances, in inspection vnet,
# with BIG-IQ association in cloud-init/DO
module "f5_google_ingress_inspect" {
  source = "../modules/gcp/autoscale_lb/1nic"
}

# Provision single-nic autoscaling instances BIG-IP instances, in inspection vnet,
# with BIG-IQ association in cloud-init/DO
module "f5_azure_ingress_inspect" {
  source = "../modules/azure/autoscale_lb/1nic"
}