# Source Infrastructure
data "terraform_remote_state" "day0" {
  backend = "local"
  config = {
    path = "../day0/terraform.tfstate"
  }
}

# Create Local object for modules
locals {
  apps_vpc = {
    vpc_id_apps          = data.terraform_remote_state.day0.outputs.vpc_id_apps
    subnets_mgmt_apps    = data.terraform_remote_state.day0.outputs.subnets_mgmt_apps
    subnets_private_apps = data.terraform_remote_state.day0.outputs.subnets_private_apps
  }
  inspect_vpc = {
    vpc_id_inspect         = data.terraform_remote_state.day0.outputs.vpc_id_inspect
    subnets_public_inspect = data.terraform_remote_state.day0.outputs.subnets_public_inspect
    nlb_target_group_arns  = data.terraform_remote_state.day0.outputs.nlb_target_group_arns
  }
}

# Retrieve AWS regional zones
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = data.aws_availability_zones.available.names
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

# Provision BIG-IQ pair in (CM/DCD) for purpose of demo in shared services vpc
module "f5_aws_management" {
  source                      = "github.com/merps/terraform-aws-bigiq"
  aws_secretmanager_secret_id = aws_secretsmanager_secret.bigiq.id
  cm_license_keys             = [var.cm_licenses]
  ec2_key_name                = var.ec2_key_name
  vpc_id                      = local.apps_vpc.vpc_id_apps
  vpc_mgmt_subnet_ids         = [local.apps_vpc.subnets_mgmt_apps]
  vpc_private_subnet_ids      = [local.apps_vpc.subnets_private_apps]
}

# Provision single-nic autoscaling instances BIG-IP instances, in inspection vpc,
# with BIG-IQ association in cloud-init/DO
module "f5_aws_ingress_inspect" {
  source                = "../modules/aws/autoscale_lb/1nic"
  vpcId                 = local.inspect_vpc.vpc_id_inspect
  extSubnetAz1          = local.inspect_vpc.subnets_public_inspect[0]
  extSubnetAz2          = local.inspect_vpc.subnets_public_inspect[1]
  allowedIps            = "0.0.0.0/0"
  f5_ssh_publickey      = "mjk-f5cs-apse2"
  nlb_target_group_arns = local.inspect_vpc.nlb_target_group_arns
}