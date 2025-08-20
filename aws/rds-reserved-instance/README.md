<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Manages an RDS DB Reserved Instance

### Usage

```hcl
module "rds_reserved_instance" {
  source = "github.com/elastic-infra/terraform-modules//aws/rds-reserved-instance?ref=v8.2.0"

  product_description = "mysql"
  db_instance_class   = "db.t2.micro"
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
| [aws_rds_reserved_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rds_reserved_instance) | resource |
| [aws_rds_reserved_instance_offering.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/rds_reserved_instance_offering) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_instance_class"></a> [db\_instance\_class](#input\_db\_instance\_class) | DB instance class for the reserved DB instance. | `string` | n/a | yes |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to reserve. | `number` | n/a | yes |
| <a name="input_product_description"></a> [product\_description](#input\_product\_description) | Description of the reserved DB instance. | `string` | n/a | yes |
| <a name="input_duration"></a> [duration](#input\_duration) | Duration of the reservation in years or seconds. | `number` | `1` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Whether the reservation applies to Multi-AZ deployments. | `bool` | `false` | no |
| <a name="input_offering_type"></a> [offering\_type](#input\_offering\_type) | Offering type of this reserved DB instance. | `string` | `"All Upfront"` | no |
| <a name="input_reservation_id"></a> [reservation\_id](#input\_reservation\_id) | Customer-specified identifier to track this reservation. | `string` | `null` | no |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
