# Source Infrastructure
data "terraform_remote_state" "vpc" {
  backend = "local"
  config = {
    path = "../day0/terraform.tfstate"
  }
}

# Retrieve AWS regional zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Initialise Random variable
resource "random_id" "id" {
  byte_length = 2
}

# Create random password for BIG-IP
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Create Secret Store and Store BIG-IP Password
resource "aws_secretsmanager_secret" "bigiq" {
  name = format("%s-secret-%s", var.tags.prefix, random_id.id.hex)
}

resource "aws_secretsmanager_secret_version" "bigiq-pwd" {
  secret_id     = aws_secretsmanager_secret.bigiq.id
  secret_string = random_password.password.result
}
#
# Create a security group for BIG-IQ Management
#
module "bigiq_mgmt_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-mgmt-sg-%s", var.tags.prefix, random_id.id.hex)
  description = "Security group for BIG-IQ Demo"
  vpc_id      = data.terraform_remote_state.vpc.outputs.aws_vpc_id_apps

  ingress_cidr_blocks = [var.allowedIps[0]]
  ingress_rules       = ["https-443-tcp", "ssh-tcp"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigiq_mgmt_sg.security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}

#
# Create a security group for BIG-IQ
#
module "bigiq_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = format("%s-sg-%s", var.tags.prefix, random_id.id.hex)
  description = "Security group for BIG-IQ Demo"
  vpc_id      = data.terraform_remote_state.vpc.outputs.aws_vpc_id_apps

  # TDDO - generate default groups into module, also - list(string) - pass it?
  ingress_cidr_blocks = [var.allowedIps[0]]
  ingress_rules       = ["https-443-tcp"]

  ingress_with_source_security_group_id = [
    {
      rule                     = "all-all"
      source_security_group_id = module.bigiq_mgmt_sg.security_group_id
    }
  ]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]
}
# Provision BIG-IQ pair in (CM/DCD) for purpose of demo in shared services vpc
module "f5_aws_management" {
  source                            = "github.com/merps/terraform-aws-bigiq"
  aws_secretmanager_secret_id       = aws_secretsmanager_secret.bigiq.id
  cm_license_keys                   = [var.cm_licenses]
  dcd_license_keys                  = [var.dcd_licenses]
  ec2_key_name                      = var.ec2_key_name
  vpc_id                            = data.terraform_remote_state.vpc.outputs.aws_vpc_id_apps
  vpc_mgmt_subnet_ids               = [
    data.terraform_remote_state.vpc.outputs.aws_subnet_ids_mgmt_apps[0],
    data.terraform_remote_state.vpc.outputs.aws_subnet_ids_mgmt_apps[1]
  ]
  vpc_private_subnet_ids            = [
    data.terraform_remote_state.vpc.outputs.aws_subnet_ids_private_apps[0],
    data.terraform_remote_state.vpc.outputs.aws_subnet_ids_private_apps[1]
    ]
  mgmt_subnet_security_group_ids    = [module.bigiq_mgmt_sg.security_group_id]
  private_subnet_security_group_ids = [module.bigiq_sg.security_group_id]
}

# Provision single-nic autoscaling instances BIG-IP instances, in inspection vpc,
# with BIG-IQ association in cloud-init/DO
module "f5_aws_ingress_inspect" {
  source                = "../modules/aws/autoscale_lb/1nic"
  vpcId                 = tostring(data.terraform_remote_state.vpc.outputs.aws_vpc_id_inspect)
  extSubnetAz1          = data.terraform_remote_state.vpc.outputs.aws_subnet_ids_public_inspect[0]
  extSubnetAz2          = data.terraform_remote_state.vpc.outputs.aws_subnet_ids_public_inspect[1]
  allowedIps            = var.allowedIps
  nlb_target_group_arns = data.terraform_remote_state.vpc.outputs.aws_nlb_target_group_arns
  resourceOwner         = var.resourceOwner
  awsRegion             = var.awsRegion
  projectPrefix         = var.projectPrefix
  f5_ssh_publickey      = var.f5_ssh_publickey
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