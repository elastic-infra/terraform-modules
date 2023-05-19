locals {
  requester_attributes = concat(var.attributes, ["requester"])
  requester_tags       = merge(var.tags, { "Side" = "requester" })
}

module "requester_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace           = var.namespace
  name                = var.name
  stage               = var.stage
  regex_replace_chars = var.regex_replace_chars
  delimiter           = var.delimiter
  attributes          = local.requester_attributes
  tags                = local.requester_tags
}

# Lookup requester VPC so that we can reference the CIDR
data "aws_vpc" "requester" {
  count = local.count
  id    = var.requester_vpc_id
  tags  = var.requester_vpc_tags
}

# Lookup requester subnets
data "aws_subnets" "requester" {
  count = local.count
  filter {
    name   = "vpc-id"
    values = [local.requester_vpc_id]
  }
}

locals {
  requester_subnet_ids       = distinct(sort(flatten(data.aws_subnets.requester.*.ids)))
  requester_subnet_ids_count = length(local.requester_subnet_ids)
  requester_vpc_id           = join("", data.aws_vpc.requester.*.id)
}

# Lookup requester route tables
data "aws_route_table" "requester" {
  count     = local.enabled ? local.requester_subnet_ids_count : 0
  subnet_id = element(local.requester_subnet_ids, count.index)
}

resource "aws_vpc_peering_connection" "requester" {
  count         = local.count
  vpc_id        = local.requester_vpc_id
  peer_vpc_id   = var.peer_vpc_id
  peer_owner_id = var.peer_owner_id
  peer_region   = var.peer_region
  auto_accept   = var.peering_auto_accept

  tags = module.requester_label.tags
}

locals {
  requester_aws_route_table_ids           = distinct(sort(data.aws_route_table.requester.*.route_table_id))
  requester_aws_route_table_ids_count     = length(local.requester_aws_route_table_ids)
  requester_cidr_block_associations       = flatten(data.aws_vpc.requester.*.cidr_block_associations)
  requester_cidr_block_associations_count = length(local.requester_cidr_block_associations)
  accepter_cidr_block_associations_count  = length(var.peer_vpc_cidr_blocks)
}

# Create routes from requester to accepter
resource "aws_route" "requester" {
  count                     = local.enabled ? local.requester_aws_route_table_ids_count * local.accepter_cidr_block_associations_count : 0
  route_table_id            = element(local.requester_aws_route_table_ids, ceil(count.index / local.accepter_cidr_block_associations_count))
  destination_cidr_block    = element(var.peer_vpc_cidr_blocks, count.index % local.accepter_cidr_block_associations_count)
  vpc_peering_connection_id = join("", aws_vpc_peering_connection.requester.*.id)
  depends_on                = [data.aws_route_table.requester, aws_vpc_peering_connection.requester]
}
