## Information

Elastic Infra - PrivateLink Consumer Resource

### Notice

Private DNS can only be enabled after the endpoint connection is accepted.

So it needs to set private_dns_enabled variable to false at your first applying.

### Usage

```hcl
module "ei_privatelink_consumer" {
  source             = "../module/aws/common/ei-privatelink-consumer"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.public_subnets
  security_group_ids = [module.vpc.default_security_group_id]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.ei_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The ID of one or more subnets in which to create a network interface for the endpoint | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the VPC Endpoints are installed | `string` | n/a | yes |
| <a name="input_ei_cidrs"></a> [ei\_cidrs](#input\_ei\_cidrs) | CIDR blocks of EI Management Environment | `list(string)` | <pre>[<br/>  "10.254.0.0/23"<br/>]</pre> | no |
| <a name="input_ei_sg_ids"></a> [ei\_sg\_ids](#input\_ei\_sg\_ids) | Security Group IDs of EI Management Environment | `list(string)` | <pre>[<br/>  "089928438340/sg-3845ff5c"<br/>]</pre> | no |
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | Whether or not to associate a private hosted zone with the specified VPC | `bool` | `true` | no |
| <a name="input_service_region"></a> [service\_region](#input\_service\_region) | Region where the endpoint service is hosted. If null, uses current region (same-region access). | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ei_managed_sg_id"></a> [ei\_managed\_sg\_id](#output\_ei\_managed\_sg\_id) | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
