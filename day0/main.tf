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

# Provision BIG-IQ pair in (CM/DCD) for purpose of demo in shared services vpc
module "f5_aws_management" {
  source                      = "github.com/merps/terraform-aws-bigiq"
  aws_secretmanager_secret_id = "abcd"
  cm_license_keys             = [var.cm_licenses]
  ec2_key_name                = var.ec2_key_name
  vpc_id                      = module.aws_iac.vpc_id_apps
  vpc_mgmt_subnet_ids         = [module.aws_iac.subnets_mgmt_apps]
  vpc_private_subnet_ids      = [module.aws_iac.subnets_private_apps]
}

# Provision single-nic autoscaling instances BIG-IP instances, in inspection vpc,
# with BIG-IQ association in cloud-init/DO
module "f5_aws_ingress_inspect" {
  source                = "../modules/aws/autoscale_lb/1nic"
  vpcId                 = module.aws_iac.vpc_id_inspect["main"]
  extSubnetAz1          = module.aws_iac.subnets_public_inspect[0]
  extSubnetAz2          = module.aws_iac.subnets_public_inspect[1]
  allowedIps            = "0.0.0.0/0"
  f5_ssh_publickey      = "mjk-f5cs-apse2"
  nlb_target_group_arns = module.aws_iac.nlb_target_group_arns
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