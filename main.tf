
locals {
    common_tags = {
    Environment = var.env
  }
}
provider "aws" {
  region     = var.region
  default_tags {
    tags = local.common_tags
  }
}

locals {
  availability_zone_1 = "${var.region}${var.availability_zone1}"
}

locals {
  availability_zone_2 = "${var.region}${var.availability_zone2}"
}
locals {
  public_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.public_subnet_index)
}
locals {
  private_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.private_subnet_index)
}
locals {
  mgmt_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.mgmt_subnet_index)
}
locals {
  tgw_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.tgw_subnet_index)
}
locals {
  public_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits,
  (var.public_subnet_index + (var.create_tgw_connect_subnets ? 4 : 3) - (var.create_ha_subnets ? 0 : 1)))
}
locals {
  private_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits,
  (var.private_subnet_index + (var.create_tgw_connect_subnets ? 4 : 3) - (var.create_ha_subnets ? 0 : 1)))
}
locals {
  mgmt_subnet_cidr_az2= cidrsubnet(var.vpc_cidr_security, var.subnet_bits,
  (var.mgmt_subnet_index + (var.create_tgw_connect_subnets ? 4 : 3) - (var.create_ha_subnets ? 0 : 1)))
}
locals {
  tgw_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits,
  (var.tgw_subnet_index + (var.create_tgw_connect_subnets ? 4 : 3) - (var.create_ha_subnets ? 0 : 1)))
}
module "vpc" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_vpc"

  vpc_name                   = "${var.cp}-${var.env}-${var.vpc_name_security}-vpc"
  vpc_cidr                   = var.vpc_cidr_security
}

resource "aws_default_route_table" "route_public" {
  default_route_table_id = module.vpc.vpc_main_route_table_id
  tags = {
    Name = "default route table for vpc (unused)"
  }
}

module "igw" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_igw"

  igw_name                   = "${var.cp}-${var.env}-igw"
  vpc_id                     = module.vpc.vpc_id
}

data "aws_subnet" "public1_cidr_block" {
  id       = module.public1-subnet.id
}

module "public1-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.cp}-${var.env}-${var.public1_description}-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_1
  subnet_cidr                = local.public_subnet_cidr_az1
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

data "aws_subnet" "private1_cidr_block" {
  id       = module.private1-subnet.id
}

module "private1-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.cp}-${var.env}-${var.private1_description}-subnet"

  vpc_id            = module.vpc.vpc_id
  availability_zone = local.availability_zone_1
  subnet_cidr       = local.private_subnet_cidr_az1
}

data "aws_subnet" "tgw1_cidr_block" {
  count = var.create_tgw_connect_subnets ? 1 : 0
  id    = var.create_tgw_connect_subnets ? module.tgw1-subnet.0.id : ""
}

module "tgw1-subnet" {
  source            = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count             = var.create_tgw_connect_subnets ? 1 : 0
  subnet_name       = "${var.cp}-${var.env}-${var.tgw1_description}-subnet"

  vpc_id            = module.vpc.vpc_id
  availability_zone = local.availability_zone_1
  subnet_cidr       = local.tgw_subnet_cidr_az1
}

data "aws_subnet" "mgmt1_cidr_block" {
  count = var.create_ha_subnets ? 1 : 0
  id    = var.create_ha_subnets ? module.mgmt1-subnet.0.id : ""
}

module "mgmt1-subnet" {
  source            = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count             = var.create_ha_subnets ? 1 : 0
  subnet_name       = "${var.cp}-${var.env}-${var.mgmt1_description}-subnet"

  vpc_id                = module.vpc.vpc_id
  availability_zone     = local.availability_zone_1
  subnet_cidr           = local.mgmt_subnet_cidr_az1
  public_route          = 1
  public_route_table_id = module.public_route_table.id
}


data "aws_subnet" "public2_cidr_block" {
  id       = module.public2-subnet.id
}

module "public2-subnet" {
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.cp}-${var.env}-${var.public2_description}-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.public_subnet_cidr_az2
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

data "aws_subnet" "private2_cidr_block" {
  id       = module.private2-subnet.id
}

module "private2-subnet" {
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.cp}-${var.env}-${var.private2_description}-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.private_subnet_cidr_az2
}

data "aws_subnet" "tgw2_cidr_block" {
  count = var.create_tgw_connect_subnets ? 1 : 0
  id    = var.create_tgw_connect_subnets ? module.tgw2-subnet.0.id : ""
}

module "tgw2-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count  = var.create_tgw_connect_subnets ? 1 : 0
  subnet_name = "${var.cp}-${var.env}-${var.tgw2_description}-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.tgw_subnet_cidr_az2
}

data "aws_subnet" "mgmt2_cidr_block" {
  count = var.create_ha_subnets ? 1 : 0
  id    = var.create_ha_subnets ? module.mgmt2-subnet.0.id : ""
}

module "mgmt2-subnet" {
  source            = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count             = var.create_ha_subnets ? 1 : 0
  subnet_name       = "${var.cp}-${var.env}-${var.mgmt2_description}-subnet"

  vpc_id                 = module.vpc.vpc_id
  availability_zone      = local.availability_zone_2
  subnet_cidr            = local.mgmt_subnet_cidr_az2
  public_route           = 1
  public_route_table_id  = module.public_route_table.id
}

module "public_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-public-rt"

  vpc_id                     = module.vpc.vpc_id
  gateway_route              = 1
  igw_id                     = module.igw.igw_id
}

module "private1_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-${var.private1_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "tgw1_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.create_tgw_connect_subnets ? 1 : 0
  rt_name = "${var.cp}-${var.env}-${var.tgw1_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "private2_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.cp}-${var.env}-${var.private2_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "tgw2_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.create_tgw_connect_subnets ? 1 : 0
  rt_name = "${var.cp}-${var.env}-${var.tgw2_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "private1_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.private1-subnet.id
  route_table_id             = module.private1_route_table.id
}

module "tgw1_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count    = var.create_tgw_connect_subnets ? 1 : 0
  subnet_ids                 = module.tgw1-subnet[0].id
  route_table_id             = module.tgw1_route_table[0].id
}

module "private2_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  subnet_ids                 = module.private2-subnet.id
  route_table_id             = module.private2_route_table.id
}

module "tgw2_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count    = var.create_tgw_connect_subnets ? 1 : 0
  subnet_ids                 = module.tgw2-subnet[0].id
  route_table_id             = module.tgw2_route_table[0].id
}
