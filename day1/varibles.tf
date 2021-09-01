variable "ec2_key_name" {
  description = "EC2 KeyPair name for instance generation"
  type        = string
}

variable "cm_licenses" {
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
