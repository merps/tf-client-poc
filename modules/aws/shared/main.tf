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
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [var.allowed_mgmt_cidr]
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
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = [var.allowed_mgmt_cidr]
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

module "bigiq" {
  source = "github.com/merps/terraform-aws-bigiq"

  admin_password = random_password.password.result
  ec2_key_name = var.ec2_key_name
  dcd_license_keys = var.dcd_license_keys
  cm_license_keys = var.cm_license_keys

  aws_secretmanager_secret_id = aws_secretsmanager_secret.bigiq.id

  mgmt_subnet_security_group_ids = [
    module.bigiq_mgmt_sg.security_group_id
  ]
  private_subnet_security_group_ids = [
    module.bigiq_sg.security_group_id
  ]
  vpc_private_subnet_ids = var.private_subnets
  vpc_mgmt_subnet_ids    = var.mgmt_subnets
  vpc_id = var.vpc_id
}
