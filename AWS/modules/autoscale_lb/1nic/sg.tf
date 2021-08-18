# Create security groups for EC2 instances
module "external-security-group" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = format("%s-external-sg-%s", var.projectPrefix, random_id.buildSuffix.hex)
  description = "Security group for BIG-IP"
  vpc_id      = var.vpcId

  ingress_cidr_blocks = var.allowedIps
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "https-8443-tcp", "ssh-tcp"]

  # Allow ec2 instances outbound Internet connectivity
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

  tags = {
    Name  = "${var.projectPrefix}-external-sg-${random_id.buildSuffix.hex}"
    Owner = var.resourceOwner
  }
}