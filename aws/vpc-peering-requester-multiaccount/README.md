<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Information

Request a VPC peering connection and build the route required to utilize the connection across VPC, accounts.
This module is a mixture with jjno91/vpc-peering-requester and cloudposse/vpc-peering-multi-account.

This modules does not affect the accepter side. It only requests a VPC peering connection and
set up the route to the peer (blackhole then) on the requester side.
Users of this module need to set up the accepter side in other means, by accepting the VPC peering connection and
set up the route to the requester.

## Usage Example

```hcl
module "peering-request" {
  source = "github.com/elastic-infra/terraform-modules//aws/vpc-peering-requester-multiaccount?ref=v2.3.0"

  enabled              = "true"
  namespace            = "foo"
  stage                = "dev"
  name                 = "bar"
  delimiter            = "-"
  requester_vpc_id     = "vpc-12345678"
  peer_owner_id        = "012345678901"
  peer_vpc_id          = "vpc-0123456789abcdef"
  peer_region          = "us-west-1"
  peer_vpc_cidr_blocks = ["192.0.2.0/24"]
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
| <a name="module_requester"></a> [requester](#module\_requester) | git::https://github.com/cloudposse/terraform-terraform-label.git | master |

## Resources

| Name | Type |
|------|------|
| [aws_route.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_vpc_peering_connection.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_peering_connection) | resource |
| [aws_route_table.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route_table) | data source |
| [aws_subnet_ids.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.requester](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`) | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace (e.g. `eg` or `cp`) | `string` | n/a | yes |
| <a name="input_peer_owner_id"></a> [peer\_owner\_id](#input\_peer\_owner\_id) | Peer VPC owner's account ID | `string` | n/a | yes |
| <a name="input_peer_vpc_cidr_blocks"></a> [peer\_vpc\_cidr\_blocks](#input\_peer\_vpc\_cidr\_blocks) | CIDR blocks associated with the peer VPC | `list(string)` | n/a | yes |
| <a name="input_peer_vpc_id"></a> [peer\_vpc\_id](#input\_peer\_vpc\_id) | Peer VPC ID | `string` | n/a | yes |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `a` or `b`) | `list(string)` | `[]` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | `string` | `"-"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating or accessing any resources | `string` | `"true"` | no |
| <a name="input_peer_region"></a> [peer\_region](#input\_peer\_region) | Region where peer VPC resides; Cannot be set when peering\_auto\_accept is true | `string` | `null` | no |
| <a name="input_peering_auto_accept"></a> [peering\_auto\_accept](#input\_peering\_auto\_accept) | Set true to enable auto-accept in an AWS account. | `bool` | `false` | no |
| <a name="input_requester_vpc_id"></a> [requester\_vpc\_id](#input\_requester\_vpc\_id) | Requester VPC ID filter | `string` | `""` | no |
| <a name="input_requester_vpc_tags"></a> [requester\_vpc\_tags](#input\_requester\_vpc\_tags) | Requester VPC Tags filter | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{"BusinessUnit" = "XYZ"`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_requester_accept_status"></a> [requester\_accept\_status](#output\_requester\_accept\_status) | Requester VPC peering connection request status |
| <a name="output_requester_connection_id"></a> [requester\_connection\_id](#output\_requester\_connection\_id) | Requester VPC peering connection ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
