locals {
    common_tags = {
    Environment = var.environment
  }
}

locals {
    id_tag = var.vpc_tag_key != "" ? tomap({(var.vpc_tag_key) = (var.vpc_tag_value)}) : {}
}

provider "aws" {
  region     = var.aws_region
  default_tags {
    tags = merge(local.common_tags, local.id_tag)
  }
}


locals {
  availability_zone_1 = "${var.aws_region}${var.availability_zone1}"
}

locals {
  availability_zone_2 = "${var.aws_region}${var.availability_zone2}"
}
locals {
  public_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.public_subnet_index)
}
locals {
  private_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.private_subnet_index)
}
locals {
  tgw_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.tgw_subnet_index)
}
locals {
  sync_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.sync_subnet_index)
}
locals {
  mgmt_subnet_cidr_az1 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, var.mgmt_subnet_index)
}
locals {
  public_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, (var.public_subnet_index * 10))
}
locals {
  private_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, (var.private_subnet_index * 10))
}
locals {
  tgw_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, (var.tgw_subnet_index * 10))
}
locals {
  sync_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, (var.sync_subnet_index * 10))
}
locals {
  mgmt_subnet_cidr_az2= cidrsubnet(var.vpc_cidr_security, var.subnet_bits, (var.mgmt_subnet_index * 10))
}
module "vpc" {
  source = "git::git@github.com:40netse/terraform-modules.git//aws_vpc"

  vpc_name                   = "${var.customer_prefix}-${var.environment}-${var.vpc_name_security}-vpc"
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

  igw_name                   = "${var.customer_prefix}-${var.environment}-igw"
  vpc_id                     = module.vpc.vpc_id
}

module "public1-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.customer_prefix}-${var.environment}-${var.public1_description}-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_1
  subnet_cidr                = local.public_subnet_cidr_az1
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

module "private1-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.customer_prefix}-${var.environment}-${var.private1_description}-subnet"

  vpc_id            = module.vpc.vpc_id
  availability_zone = local.availability_zone_1
  subnet_cidr       = local.private_subnet_cidr_az1
}

module "tgw1-subnet" {
  source            = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count             = var.create_tgw_connect_subnets ? 1 : 0
  subnet_name       = "${var.customer_prefix}-${var.environment}-${var.tgw1_description}-subnet"

  vpc_id            = module.vpc.vpc_id
  availability_zone = local.availability_zone_1
  subnet_cidr       = local.tgw_subnet_cidr_az1
}

module "sync1-subnet" {
  source            = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count             = var.create_ha_subnets ? 1 : 0
  subnet_name       = "${var.customer_prefix}-${var.environment}-${var.sync1_description}-subnet"

  vpc_id            = module.vpc.vpc_id
  availability_zone = local.availability_zone_1
  subnet_cidr       = local.sync_subnet_cidr_az1
}

module "mgmt1-subnet" {
  source            = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count             = var.create_ha_subnets ? 1 : 0
  subnet_name       = "${var.customer_prefix}-${var.environment}-${var.mgmt1_description}-subnet"

  vpc_id            = module.vpc.vpc_id
  availability_zone = local.availability_zone_1
  subnet_cidr       = local.mgmt_subnet_cidr_az1
}

module "public2-subnet" {
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.customer_prefix}-${var.environment}-${var.public2_description}-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.public_subnet_cidr_az2
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

module "private2-subnet" {
  source      = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  subnet_name = "${var.customer_prefix}-${var.environment}-${var.private2_description}-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.private_subnet_cidr_az2
}

module "tgw2-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count  = var.create_tgw_connect_subnets ? 1 : 0
  subnet_name = "${var.customer_prefix}-${var.environment}-${var.tgw2_description}-subnet"

  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.tgw_subnet_cidr_az2
}

module "sync2-subnet" {
  source            = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count             = var.create_ha_subnets ? 1 : 0
  subnet_name       = "${var.customer_prefix}-${var.environment}-${var.sync2_description}-subnet"

  vpc_id            = module.vpc.vpc_id
  availability_zone = local.availability_zone_2
  subnet_cidr       = local.sync_subnet_cidr_az2
}

module "mgmt2-subnet" {
  source            = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"
  count             = var.create_ha_subnets ? 1 : 0
  subnet_name       = "${var.customer_prefix}-${var.environment}-${var.mgmt2_description}-subnet"

  vpc_id            = module.vpc.vpc_id
  availability_zone = local.availability_zone_2
  subnet_cidr       = local.mgmt_subnet_cidr_az2
}

module "public_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.customer_prefix}-${var.environment}-public-rt"

  vpc_id                     = module.vpc.vpc_id
  gateway_route              = 1
  igw_id                     = module.igw.igw_id
}

module "private1_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.customer_prefix}-${var.environment}-${var.private1_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "tgw1_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.create_tgw_connect_subnets ? 1 : 0
  rt_name = "${var.customer_prefix}-${var.environment}-${var.tgw1_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "sync1_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.create_ha_subnets ? 1 : 0
  rt_name = "${var.customer_prefix}-${var.environment}-${var.sync1_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "mgmt1_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.create_ha_subnets ? 1 : 0
  rt_name = "${var.customer_prefix}-${var.environment}-${var.mgmt1_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "private2_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  rt_name = "${var.customer_prefix}-${var.environment}-${var.private2_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "tgw2_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.create_tgw_connect_subnets ? 1 : 0
  rt_name = "${var.customer_prefix}-${var.environment}-${var.tgw2_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "sync2_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.create_ha_subnets ? 1 : 0
  rt_name = "${var.customer_prefix}-${var.environment}-${var.sync2_description}-rt"

  vpc_id                     = module.vpc.vpc_id
}

module "mgmt2_route_table" {
  source  = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  count   = var.create_ha_subnets ? 1 : 0
  rt_name = "${var.customer_prefix}-${var.environment}-${var.mgmt2_description}-rt"

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

module "sync1_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count   = var.create_ha_subnets ? 1 : 0
  subnet_ids                 = module.sync1-subnet[0].id
  route_table_id             = module.sync1_route_table[0].id
}

module "mgmt1_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count   = var.create_ha_subnets ? 1 : 0
  subnet_ids                 = module.mgmt1-subnet[0].id
  route_table_id             = module.mgmt1_route_table[0].id
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

module "sync2_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count   = var.create_ha_subnets ? 1 : 0
  subnet_ids                 = module.sync2-subnet[0].id
  route_table_id             = module.sync2_route_table[0].id
}

module "mgmt2_route_table_association" {
  source   = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"
  count   = var.create_ha_subnets ? 1 : 0
  subnet_ids                 = module.mgmt2-subnet[0].id
  route_table_id             = module.mgmt2_route_table[0].id
}
