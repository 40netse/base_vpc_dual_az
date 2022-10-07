variable "region" {
  description = "The AWS region to use"
}
variable "cp" {
  description = "Customer Prefix to apply to all resources"
}
variable "env" {
  description = "The Tag Environment to differentiate prod/test/dev"
}
variable "availability_zone1" {
  description = "Availability Zone 1 for VPC"
}
variable "availability_zone2" {
  description = "Availability Zone 2 for VPC"
}
variable "create_tgw_connect_subnets" {
  description = "Boolean for creating the tgw connect subnets"
  type        = bool
  default     = false
}
variable "create_ha_subnets" {
  description = "Boolean for creating the HA subnets"
  type        = bool
  default     = false
}
variable "vpc_name_security" {
  description = "VPC Name"
}
variable "vpc_cidr_security" {
    description = "CIDR for the whole VPC"
}
variable subnet_bits {
  description = "Number of bits in the network portion of the subnet CIDR"
}
variable "public_subnet_index" {
  description = "Index of the public subnet"
  default = 0
}
variable "private_subnet_index" {
  description = "Index of the private subnet"
  default = 1
}
variable "mgmt_subnet_index" {
  description = "Index of the sync subnet"
  default = 2
}
variable "tgw_subnet_index" {
  description = "Index of the tgw subnet"
  default = 3
}
variable "public1_description" {
    description = "Description Public Subnet 1 TAG"
}
variable "private1_description" {
    description = "Description Private Subnet 1 TAG"
}
variable "tgw1_description" {
    description = "Description TGW Subnet 1 TAG"
    default = ""
}
variable "mgmt1_description" {
    description = "Description Mgmt Subnet 1 TAG"
    default = ""
}
variable "public2_description" {
    description = "Description Public Subnet 2 TAG"
}
variable "private2_description" {
    description = "Description Private Subnet 2 TAG"
}
variable "tgw2_description" {
    description = "Description TGW Subnet 2 TAG"
    default = ""
}
variable "mgmt2_description" {
    description = "Description Mgmt Subnet 2 TAG"
    default = ""
}

