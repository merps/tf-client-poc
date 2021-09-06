output "aws_nlb_target_group_arns" {
  value = module.aws_iac.nlb_target_group_arns
}

output "aws_public_vip" {
  value = module.aws_iac.nlb_target_group_arns
}

output "aws_public_vip_url" {
  value = module.aws_iac.nlb_target_group_arns
}

output "aws_vpc_id_apps" {
  value = module.aws_iac.vpc_id_apps
}

output "aws_vpc_id_gateway" {
  value = module.aws_iac.vpc_id_gateway
}

output "aws_vpc_id_inspect" {
  value = module.aws_iac.vpc_id_inspect
}

output "aws_subnet_ids_mgmt_apps" {
  value = module.aws_iac.subnets_mgmt_apps
}

output "aws_subnet_ids_mgmt_gateway" {
  value = module.aws_iac.subnets_mgmt_gateway
}

output "aws_subnet_ids_mgmt_inspect" {
  value = module.aws_iac.subnets_mgmt_inspect
}

output "aws_subnet_ids_private_apps" {
  value = module.aws_iac.subnets_private_apps
}

output "aws_subnet_ids_private_gateway" {
  value = module.aws_iac.subnets_private_gateway
}

output "aws_subnets_ids_private_inspect" {
  value = module.aws_iac.subnets_private_inspect
}

output "aws_subnet_ids_public_apps" {
  value = module.aws_iac.subnets_public_apps
}

output "aws_subnet_ids_public_gateway" {
  value = module.aws_iac.subnets_public_gateway
}

output "aws_subnet_ids_public_inspect" {
  value = module.aws_iac.subnets_public_inspect
}
