provider "aws" {
  alias  = "accepter"
  region = var.accepter_region
}

locals {
  accepter_attributes = concat(var.attributes, list("accepter"))
  accepter_tags       = merge(var.tags, map("Side", "accepter"))
}

module "accepter" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=master"
  enabled    = var.enabled
  namespace  = var.namespace
  name       = var.name
  stage      = var.stage
  delimiter  = var.delimiter
  attributes = local.accepter_attributes
  tags       = local.accepter_tags
}

# Lookup accepter VPC so that we can reference the CIDR
data "aws_vpc" "accepter" {
  count    = local.count
  provider = aws.accepter
  id       = var.accepter_vpc_id
  tags     = var.accepter_vpc_tags
}

# Lookup accepter subnets
data "aws_subnet_ids" "accepter" {
  count    = local.count
  provider = aws.accepter
  vpc_id   = local.accepter_vpc_id
}

locals {
  accepter_subnet_ids       = distinct(sort(flatten(data.aws_subnet_ids.accepter.*.ids)))
  accepter_subnet_ids_count = length(local.accepter_subnet_ids)
  accepter_vpc_id           = join("", data.aws_vpc.accepter.*.id)
}

# Lookup peering connection
data "aws_vpc_peering_connection" "peering" {
  count    = local.count
  provider = aws.accepter
  id       = var.vpc_peering_id
}

# Lookup accepter route tables
data "aws_route_table" "accepter" {
  count     = local.enabled ? local.accepter_subnet_ids_count : 0
  provider  = aws.accepter
  subnet_id = element(local.accepter_subnet_ids, count.index)
}

locals {
  vpc_peering_connection_id = local.count > 0 ? data.aws_vpc_peering_connection.peering[0].id : ""
}

resource "aws_vpc_peering_connection_accepter" "accepter" {
  provider                  = aws.accepter
  vpc_peering_connection_id = local.vpc_peering_connection_id
  auto_accept               = true
  tags                      = module.accepter.tags
}

locals {
  accepter_aws_route_table_ids            = distinct(sort(data.aws_route_table.accepter.*.route_table_id))
  accepter_aws_route_table_ids_count      = length(local.accepter_aws_route_table_ids)
  accepter_cidr_block_associations        = flatten(data.aws_vpc.accepter.*.cidr_block_associations)
  accepter_cidr_block_associations_count  = length(local.accepter_cidr_block_associations)
  requester_cidr_block_associations       = var.requester_vpc_cidr_blocks
  requester_cidr_block_associations_count = length(local.requester_cidr_block_associations)
}

resource "aws_route" "to_requester" {
  count                     = local.enabled ? local.accepter_aws_route_table_ids_count * local.requester_cidr_block_associations_count : 0
  provider                  = aws.accepter
  route_table_id            = element(local.accepter_aws_route_table_ids, ceil(count.index / local.requester_cidr_block_associations_count))
  destination_cidr_block    = element(local.requester_cidr_block_associations, count.index % local.requester_cidr_block_associations_count)
  vpc_peering_connection_id = local.vpc_peering_connection_id
}
