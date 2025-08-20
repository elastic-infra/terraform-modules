/**
* ## Information
*
* Manages an ElastiCache Reserved Cache Node
*
* ### Usage
*
* ```hcl
* module "elasticache_reserved_cache_node" {
*   source = "github.com/elastic-infra/terraform-modules//aws/elasticache-reserved-cache-node?ref=v8.2.0"
*
*   product_description = "redis"
*   db_instance_class   = "cache.t4g.small"
*   instance_count      = 1
* }
* ```
*
*/

data "aws_elasticache_reserved_cache_node_offering" "this" {
  cache_node_type     = var.cache_node_type
  duration            = var.duration
  offering_type       = var.offering_type
  product_description = var.product_description
}

resource "aws_elasticache_reserved_cache_node" "this" {
  reserved_cache_nodes_offering_id = data.aws_elasticache_reserved_cache_node_offering.this.offering_id
  id                               = var.reservation_id
  cache_node_count                 = var.cache_node_count
}
