
provider "aws" {
  region     = var.aws_region
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
  public_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, (var.public_subnet_index * 10))
}
locals {
  private_subnet_cidr_az2 = cidrsubnet(var.vpc_cidr_security, var.subnet_bits, (var.private_subnet_index * 10))
}

module "vpc" {
  source = "git::git@github.com:40netse/terraform-modules.git//aws_vpc"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_name                   = var.vpc_name_security
  vpc_cidr                   = var.vpc_cidr_security
  vpc_tag_value              = var.vpc_tag_value
}

resource "aws_default_route_table" "route_public" {
  default_route_table_id = module.vpc.vpc_main_route_table_id
  tags = {
    Name = "default route table for vpc (unused)"
  }
}

module "igw" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_igw"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
}

module "public1-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_1
  subnet_cidr                = local.public_subnet_cidr_az1
  subnet_description         = var.public1_description
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

module "private1-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_1
  subnet_cidr                = local.private_subnet_cidr_az1
  subnet_description         = var.private1_description
}

module "public2-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.public_subnet_cidr_az2
  subnet_description         = var.public2_description
  public_route               = 1
  public_route_table_id      = module.public_route_table.id
}

module "private2-subnet" {
  source = "git::https://github.com/40netse/terraform-modules.git//aws_subnet"

  aws_region                 = var.aws_region
  environment                = var.environment
  customer_prefix            = var.customer_prefix
  vpc_id                     = module.vpc.vpc_id
  availability_zone          = local.availability_zone_2
  subnet_cidr                = local.private_subnet_cidr_az2
  subnet_description         = var.private2_description
}

module "public_route_table" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  gateway_route              = 1
  igw_id                     = module.igw.igw_id
  route_description          = "Public Route Table"
}

module "private1_route_table" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  route_description          = "Private 1 Route Table"
}


module "private1_route_table_association" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  subnet_ids                 = module.private1-subnet.id
  route_table_id             = module.private1_route_table.id
}

module "private2_route_table" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table"
  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  route_description          = "Private 2 Route Table"
}

module "private2_route_table_association" {
  source                     = "git::https://github.com/40netse/terraform-modules.git//aws_route_table_association"

  aws_region                 = var.aws_region
  customer_prefix            = var.customer_prefix
  environment                = var.environment
  subnet_ids                 = module.private2-subnet.id
  route_table_id             = module.private2_route_table.id
}
