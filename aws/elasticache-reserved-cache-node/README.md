<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Manages an ElastiCache Reserved Cache Node

### Usage

```hcl
module "elasticache_reserved_cache_node" {
  source = "github.com/elastic-infra/terraform-modules//aws/elasticache-reserved-cache-node?ref=v8.2.0"

  product_description = "redis"
  db_instance_class   = "cache.t4g.small"
  instance_count      = 1
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_reserved_cache_node.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_reserved_cache_node) | resource |
| [aws_elasticache_reserved_cache_node_offering.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elasticache_reserved_cache_node_offering) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cache_node_type"></a> [cache\_node\_type](#input\_cache\_node\_type) | Node type for the reserved cache node. | `string` | n/a | yes |
| <a name="input_product_description"></a> [product\_description](#input\_product\_description) | Engine type for the reserved cache node. | `string` | n/a | yes |
| <a name="input_cache_node_count"></a> [cache\_node\_count](#input\_cache\_node\_count) | Number of cache node instances to reserve. | `number` | `1` | no |
| <a name="input_duration"></a> [duration](#input\_duration) | Duration of the reservation in RFC3339 duration format. | `string` | `"P1Y"` | no |
| <a name="input_offering_type"></a> [offering\_type](#input\_offering\_type) | Offering type of this reserved cache node. | `string` | `"All Upfront"` | no |
| <a name="input_reservation_id"></a> [reservation\_id](#input\_reservation\_id) | Customer-specified identifier to track this reservation. | `string` | `null` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
