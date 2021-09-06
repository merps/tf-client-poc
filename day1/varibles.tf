variable "allowedIps" {
  type = list(string)
}

variable "projectPrefix" {
  type = string
}

variable "resourceOwner" {
  type = string
}

variable "cm_licenses" {
  type = string
}

variable "dcd_licenses" {
  type    = string
  default = "skipLicense"
}

variable "f5_ssh_publickey" {
  type = string
}

variable "ec2_key_name" {
  type = string
}

variable "awsRegion" {
  type    = string
  default = "ap-southeast-2"
}

variable "tags" {
  description = "AWS Tags"
  type = object({
    prefix      = string
    environment = string
  })
  default = {
    prefix      = "f5-sslo"
    environment = "demo"
  }
}