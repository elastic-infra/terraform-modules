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
    aws.accepter = aws.us-east-1
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| aws.accepter | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name  (e.g. `app` or `cluster`) | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | n/a | yes |
| requester\_vpc\_cidr\_blocks | CIDR blocks associated with the peer VPC (it should be fetched via VPC peering information but terraform-provider-aws does not read CidrBlockSet) | `list(string)` | n/a | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| vpc\_peering\_id | VPC peering ID to be accepted | `string` | n/a | yes |
| accepter\_vpc\_id | Accepter VPC ID filter | `string` | `""` | no |
| accepter\_vpc\_tags | Accepter VPC Tags filter | `map(string)` | `{}` | no |
| attributes | Additional attributes (e.g. `a` or `b`) | `list(string)` | `[]` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | `string` | `"-"` | no |
| enabled | Set to false to prevent the module from creating or accessing any resources | `string` | `"true"` | no |
| tags | Additional tags (e.g. `{"BusinessUnit" = "XYZ"`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| accepting\_vpc\_peering | Accepting VPC peering ID |
| vpc\_peering\_status | Status of accepting VPC peering |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
