variable "vpc_id" {
  type = string
}
variable "mgmt_subnets" {
  type = list(string)
}
variable "private_subnets" {
  type = list(string)
}
variable "ec2_public_key" {
  type = string
}
variable "dcd_license_keys" {
  type = list(string)
}
variable "cm_license_keys" {
  type = list(string)
}
variable "allowed_mgmt_cidr" {
  type = string
}
variable "ec2_key_name" {
  type = string
}
variable "tags" {
  description = "AWS Tags"
  type = object({
    prefix      = string
    environment = string
  })
  default = {
    prefix = "tf-poc"
    environment = "demo"
  }
}
