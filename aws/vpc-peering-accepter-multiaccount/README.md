<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Accepts a VPC peering connection and build the route required to utilize the connection across VPC, accounts.
This module is a mixture with jjno91/vpc-peering-accepter and cloudposse/vpc-peering-multi-account.

This modules does not affect the requester side. It only accepts a VPC peering connection and
set up the route to the peer on the accepter side.
Users of this module need to set up the requester side in other means in advance.

## Usage Example

```hcl
module "peering_acceptance" {
  source = "github.com/elastic-infra/terraform-modules//aws/vpc-peering-accepter-multiaccount?ref=v2.3.0"

  enabled                   = "true"
  namespace                 = "foo"
  stage                     = "dev"
  name                      = "bar"
  delimiter                 = "-"
  requester_vpc_cidr_blocks = ["198.51.100/24"]
  accepter_vpc_id           = "vpc-0123456789"
  vpc_peering_id            = "pcx-0123456789abcdef"

  tags {
    Environment = "development"
  }

  providers = {
    aws = aws.us-east-1
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_accepter_label"></a> [accepter\_label](#module\_accepter\_label) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route.to_requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection_accepter.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection_accepter) | resource |
| [aws_route_table.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnets.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.accepter](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [aws_vpc_peering_connection.peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_peering_connection) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (e.g. `eg` or `cp`) | `string` | n/a | yes |
| <a name="input_requester_vpc_cidr_blocks"></a> [requester\_vpc\_cidr\_blocks](#input\_requester\_vpc\_cidr\_blocks) | CIDR blocks associated with the peer VPC (it should be fetched via VPC peering information but terraform-provider-aws does not read CidrBlockSet) | `list(string)` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| <a name="input_vpc_peering_id"></a> [vpc\_peering\_id](#input\_vpc\_peering\_id) | VPC peering ID to be accepted | `string` | n/a | yes |
| <a name="input_accepter_vpc_id"></a> [accepter\_vpc\_id](#input\_accepter\_vpc\_id) | Accepter VPC ID filter | `string` | `""` | no |
| <a name="input_accepter_vpc_tags"></a> [accepter\_vpc\_tags](#input\_accepter\_vpc\_tags) | Accepter VPC Tags filter | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `a` or `b`) | `list(string)` | `[]` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | `string` | `"-"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating or accessing any resources | `string` | `"true"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{"BusinessUnit" = "XYZ"`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepting_vpc_peering"></a> [accepting\_vpc\_peering](#output\_accepting\_vpc\_peering) | Accepting VPC peering ID |
| <a name="output_vpc_peering_status"></a> [vpc\_peering\_status](#output\_vpc\_peering\_status) | Status of accepting VPC peering |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
