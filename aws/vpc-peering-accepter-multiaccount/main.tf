/**
* ## Information
*
* Accepts a VPC peering connection and build the route required to utilize the connection across VPC, accounts.
* This module is a mixture with jjno91/vpc-peering-accepter and cloudposse/vpc-peering-multi-account.
*
* This modules does not affect the requester side. It only accepts a VPC peering connection and
* set up the route to the peer on the accepter side.
* Users of this module need to set up the requester side in other means in advance.
*
* ## Usage Example
*
* ```hcl
* module "peering_acceptance" {
*   source = "github.com/elastic-infra/terraform-modules//aws/vpc-peering-accepter-multiaccount?ref=v1.2.0"
*
*   enabled                   = "true"
*   namespace                 = "foo"
*   stage                     = "dev"
*   name                      = "bar"
*   delimiter                 = "-"
*   requester_vpc_cidr_blocks = ["198.51.100/24"]
*   accepter_region           = "us-east-1"
*   accepter_vpc_id           = "vpc-0123456789"
*   vpc_peering_id            = "pcx-0123456789abcdef"
*
*   tags {
*     Environment = "development"
*   }
* }
* ```
*/

locals {
  enabled = var.enabled == "true"
  count   = local.enabled ? 1 : 0
}
