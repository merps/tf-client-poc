variable "ec2_key_name" {
  description = "EC2 KeyPair name for instance generation"
  type        = string
}

variable "cm_licenses" {
  type = list(string)
}