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
variable "licenses" {
  type = object({
    cm_key = string
    dcd_key = string
  })
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
