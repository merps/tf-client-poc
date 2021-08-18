module "aws_iac" {
  source = "../AWS/modules/IaC"
}

module "google_iac" {
  source = "../GCP/modules/IaC"
}

module "f5_aws_ingress_inspect" {
  source                = "../AWS/modules/autoscale_lb/1nic"
  vpcId                 = module.aws_iac.vpc_id_inspect["main"]
  extSubnetAz1          = module.aws_iac.subnets_public_inspect[0]
  extSubnetAz2          = module.aws_iac.subnets_public_inspect[1]
  allowedIps            = "0.0.0.0/0"
  f5_ssh_publickey      = "mjk-f5cs-apse2"
  nlb_target_group_arns = module.aws_iac.nlb_target_group_arns
}

module "f5_google_ingress_inspect" {
  source = "../GCP/modules/autoscale_lb/1nic"
}