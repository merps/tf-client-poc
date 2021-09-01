# Ingress Inspection VPC Outputs
output "subnets_public_inspect" {
  value = [module.aws_vpc_inspect.subnetsAz2["public"], module.aws_vpc_inspect.subnetsAz1["public"]]
}

output "subnets_private_inspect" {
  value = [module.aws_vpc_inspect.subnetsAz2["private"], module.aws_vpc_inspect.subnetsAz1["private"]]
}

output "subnets_mgmt_inspect" {
  value = [module.aws_vpc_inspect.subnetsAz2["mgmt"], module.aws_vpc_inspect.subnetsAz1["mgmt"]]
}

output "vpc_id_inspect" {
  value = module.aws_vpc_inspect.vpcs["main"]
}

# Internet facing NLB Outputs
output "public_vip" {
  value = module.nlb.lb_dns_name
}

output "public_vip_url" {
  value = "http://${module.nlb.lb_dns_name}"
}

output "nlb_target_group_arns" {
  value = module.nlb.target_group_arns
}

# Security Gateway VPC Outputs
output "subnets_public_gateway" {
  value = [module.aws_vpc_gateway.subnetsAz2["public"], module.aws_vpc_gateway.subnetsAz1["public"]]
}

output "subnets_private_gateway" {
  value = [module.aws_vpc_gateway.subnetsAz2["private"], module.aws_vpc_gateway.subnetsAz1["private"]]
}

output "subnets_mgmt_gateway" {
  value = [module.aws_vpc_gateway.subnetsAz2["mgmt"], module.aws_vpc_gateway.subnetsAz1["mgmt"]]
}

output "vpc_id_gateway" {
  value = module.aws_vpc_gateway.vpcs["main"]
}

# Application VPC Outputs
output "subnets_public_apps" {
  value = [module.aws_vpc_apps.subnetsAz2["public"], module.aws_vpc_apps.subnetsAz1["public"]]
}

output "subnets_private_apps" {
  value = [module.aws_vpc_apps.subnetsAz2["private"], module.aws_vpc_apps.subnetsAz1["private"]]
}

output "subnets_mgmt_apps" {
  value = [module.aws_vpc_apps.subnetsAz2["mgmt"], module.aws_vpc_apps.subnetsAz1["mgmt"]]
}

output "vpc_id_apps" {
  value = module.aws_vpc_apps.vpcs["main"]
}