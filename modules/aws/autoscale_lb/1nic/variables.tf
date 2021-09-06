# Variables

# AWS Environment
variable "awsRegion" {}
variable "projectPrefix" {}
variable "resourceOwner" {}


# NETWORK
variable "vpcId" {}
variable "extSubnetAz1" {}
variable "extSubnetAz2" {}
variable  "nlb_target_group_arns" {}

# AWS LB, auto healing, and auto scaling
variable "asg_min_size" { default = 1 }
variable "asg_max_size" { default = 2 }
variable "asg_desired_capacity" { default = 1 }

# BIGIP Image
variable "f5_ami_search_name" { default = "F5 BIGIP-15.1.2.1* PAYG-Best 200Mbps*" }
variable "ec2_instance_type" { default = "m5.xlarge" }

# BIGIP Setup
variable "f5_username" { default = "admin" }
variable "f5_password" { default = "Default12345!" }
variable "f5_ssh_publickey" {}
variable "allowedIps" {}
variable "onboard_log" { default = "/var/log/cloud/onboard.log" }

# BIGIQ License Manager Setup
variable "bigIqHost" { default = "200.200.200.200" }
variable "bigIqUsername" { default = "admin" }
variable "bigIqPassword" { default = "Default12345!" }
variable "bigIqLicenseType" { default = "licensePool" }
variable "bigIqLicensePool" { default = "myPool" }
variable "bigIqSkuKeyword1" { default = "key1" }
variable "bigIqSkuKeyword2" { default = "key2" }
variable "bigIqUnitOfMeasure" { default = "hourly" }
variable "bigIqHypervisor" { default = "aws" }
