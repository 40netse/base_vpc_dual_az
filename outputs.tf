output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "The VPC Id of the newly created VPC."
}
output "public1_subnet_id" {
  value = module.public1-subnet.id
  description = "The Subnet Id of the newly created Public 1 Subnet"
}
output "private1_subnet_id" {
  value = module.private1-subnet.id
  description = "The Subnet Id of the newly created Private 1 Subnet"
}
output "tgw1_subnet_id" {
  value = module.tgw1-subnet[*].id
  description = "The Subnet Id of the newly created TGW 1 Subnet"
}
output "mgmt1_subnet_id" {
  value = module.mgmt1-subnet[*].id
  description = "The Subnet Id of the newly created MGMT 1 Subnet"
}
output "public2_subnet_id" {
  value = module.public2-subnet.id
  description = "The Subnet Id of the newly created Public 2 Subnet"
}
output "private2_subnet_id" {
  value = module.private2-subnet.id
  description = "The Subnet Id of the newly created Private 2 Subnet"
}
output "tgw2_subnet_id" {
  value = module.tgw2-subnet[*].id
    description = "The Subnet Id of the newly created TGW 2 Subnet"
}
output "mgmt2_subnet_id" {
  value = module.mgmt2-subnet[*].id
    description = "The Subnet Id of the newly created MGMT 2 Subnet"
}
output "vpc_main_route_table_id" {
  value = module.vpc.vpc_main_route_table_id
  description = "Id of the VPC default route table"
}
output "public_route_table_id" {
  value = module.public_route_table.id
  description = "Id of the VPC Public Route Table"
}
output "private1_route_table_id" {
  value = module.private1_route_table.id
  description = "Id of the VPC Private 1 Route Table"
}
output "tgw1_route_table_id" {
  value = module.tgw1_route_table[*].id
  description = "Id of the VPC Private 1 Route Table"
}
output "private2_route_table_id" {
  value = module.private2_route_table.id
  description = "Id of the VPC Private 2 Route Table"
}
output "tgw2_route_table_id" {
  value = module.tgw2_route_table[*].id
  description = "Id of the VPC Private 2 Route Table"
}

output "cidr1_public1" {
  value = data.aws_subnet.public1_cidr_block.cidr_block
  description = "Calculated CIDR for Subnet Public 1"
}
output "cidr1_public2" {
  value = data.aws_subnet.public2_cidr_block.cidr_block
  description = "Calculated CIDR for Subnet Public 2"
}
output "cidr2_private1" {
  value = data.aws_subnet.private1_cidr_block.cidr_block
  description = "Calculated CIDR for Subnet Public 1"
}
output "cidr2_private2" {
  value = data.aws_subnet.private2_cidr_block.cidr_block
  description = "Calculated CIDR for Subnet Private 2"
}

output "cidr3_mgmt1" {
  value = var.create_ha_subnets ? data.aws_subnet.mgmt1_cidr_block.*.cidr_block : [ "NA" ]
  description = "Calculated CIDR for Subnet Mgmt 1"
}
output "cidr3_mgmt2" {
  value = var.create_ha_subnets ? data.aws_subnet.mgmt1_cidr_block.*.cidr_block : [ "NA" ]
  description = "Calculated CIDR for Subnet Mgmt 2"
}

output "cidr4_tgw1" {
  value = var.create_tgw_connect_subnets ? data.aws_subnet.tgw1_cidr_block.*.cidr_block : [ "NA" ]
  description = "Calculated CIDR for Subnet TGW 1"
}

output "cidr4_tgw2" {
  value = var.create_tgw_connect_subnets ? data.aws_subnet.tgw2_cidr_block.*.cidr_block : [ "NA" ]
  description = "Calculated CIDR for Subnet TGW 2"
}
