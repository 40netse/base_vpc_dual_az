variable "aws_region" {
  description = "The AWS region to use"
}
variable "availability_zone1" {
  description = "Availability Zone 1 for VPC"
}
variable "availability_zone2" {
  description = "Availability Zone 2 for VPC"
}
variable "customer_prefix" {
  description = "Customer Prefix to apply to all resources"
}
variable "environment" {
  description = "The Tag Environment to differentiate prod/test/dev"
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
}
variable "private_subnet_index" {
  description = "Index of the private subnet"
}
variable "public1_description" {
    description = "Description Public Subnet 1 TAG"
}
variable "private1_description" {
    description = "Description Private Subnet 1 TAG"
}
variable "public2_description" {
    description = "Description Public Subnet 2 TAG"
}
variable "private2_description" {
    description = "Description Private Subnet 2 TAG"
}
variable "vpc_tag_value" {
    description = "Random Tag Value to place on VPC for data ID"
    default     = ""
}

