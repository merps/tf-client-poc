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

module "big_iq_byol" {
  source = "github.com/merps/terraform-aws-bigiq"
  aws_secretmanager_secret_id = aws_secretsmanager_secret.bigiq.id
  cm_license_keys = [ var.licenses.cm_key ]
  ec2_key_name = var.ec2_public_key
  vpc_id = var.vpc_id
  vpc_mgmt_subnet_ids = var.mgmt_subnets
  vpc_private_subnet_ids = var.private_subnets
}
