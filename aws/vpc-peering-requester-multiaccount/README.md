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
    aws.requester = aws.us-east-1
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
| aws.requester | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name  (e.g. `app` or `cluster`) | `string` | n/a | yes |
| namespace | Namespace (e.g. `eg` or `cp`) | `string` | n/a | yes |
| peer\_owner\_id | Peer VPC owner's account ID | `string` | n/a | yes |
| peer\_region | Region where peer VPC resides | `string` | n/a | yes |
| peer\_vpc\_cidr\_blocks | CIDR blocks associated with the peer VPC | `list(string)` | n/a | yes |
| peer\_vpc\_id | Peer VPC ID | `string` | n/a | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `string` | n/a | yes |
| attributes | Additional attributes (e.g. `a` or `b`) | `list(string)` | `[]` | no |
| delimiter | Delimiter to be used between `namespace`, `stage`, `name`, and `attributes` | `string` | `"-"` | no |
| enabled | Set to false to prevent the module from creating or accessing any resources | `string` | `"true"` | no |
| requester\_vpc\_id | Requester VPC ID filter | `string` | `""` | no |
| requester\_vpc\_tags | Requester VPC Tags filter | `map(string)` | `{}` | no |
| tags | Additional tags (e.g. `{"BusinessUnit" = "XYZ"`) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| requester\_accept\_status | Requester VPC peering connection request status |
| requester\_connection\_id | Requester VPC peering connection ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
