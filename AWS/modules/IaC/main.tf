# Main

# Create a random id
resource "random_id" "buildSuffix" {
  byte_length = 2
}

# Networking

# Create VPC, subnets, route tables, and IGW
module "aws_vpc_inspect" {
  source                  = "github.com/f5devcentral/f5-digital-customer-engagement-center//modules/aws/terraform/network/min?ref=v1.1.0"
  projectPrefix           = format("inspect-%s", var.projectPrefix)
  buildSuffix             = random_id.buildSuffix.hex
  resourceOwner           = var.resourceOwner
  map_public_ip_on_launch = true
}

module "aws_vpc_gateway" {
  source                  = "github.com/f5devcentral/f5-digital-customer-engagement-center//modules/aws/terraform/network/min?ref=v1.1.0"
  projectPrefix           = format("gateway-%s", var.projectPrefix)
  buildSuffix             = random_id.buildSuffix.hex
  resourceOwner           = var.resourceOwner
  map_public_ip_on_launch = false
}

module "aws_vpc_apps" {
  source                  = "github.com/f5devcentral/f5-digital-customer-engagement-center//modules/aws/terraform/network/min?ref=v1.1.0"
  projectPrefix           = format("apps-%s", var.projectPrefix)
  buildSuffix             = random_id.buildSuffix.hex
  resourceOwner           = var.resourceOwner
  map_public_ip_on_launch = false
}

# AWS Network Load Balancer

module "nlb" {
  source             = "terraform-aws-modules/alb/aws"
  name               = format("%s-nlb-%s", var.projectPrefix, random_id.buildSuffix.hex)
  load_balancer_type = "network"
  vpc_id             = module.aws_vpc_inspect.vpcs["main"]
  subnets            = [module.aws_vpc_inspect.subnetsAz1["public"], module.aws_vpc_inspect.subnetsAz2["public"]]

  target_groups = [
    {
      name_prefix      = "tg-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
    }
  ]

  tags = {
    Name  = "${var.projectPrefix}-nlb-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}