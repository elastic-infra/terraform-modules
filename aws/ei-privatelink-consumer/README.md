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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.ei_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | The ID of one or more subnets in which to create a network interface for the endpoint | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where the VPC Endpoints are installed | `string` | n/a | yes |
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | Whether or not to associate a private hosted zone with the specified VPC | `bool` | `true` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region of the VPC Endpoints | `string` | `"ap-northeast-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ei_managed_sg_id"></a> [ei\_managed\_sg\_id](#output\_ei\_managed\_sg\_id) | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
