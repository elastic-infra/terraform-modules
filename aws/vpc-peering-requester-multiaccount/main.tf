/**
* ## Information
*
* Request a VPC peering connection and build the route required to utilize the connection across VPC, accounts.
* This module is a mixture with jjno91/vpc-peering-requester and cloudposse/vpc-peering-multi-account.
*
* This modules does not affect the accepter side. It only requests a VPC peering connection and
* set up the route to the peer (blackhole then) on the requester side.
* Users of this module need to set up the accepter side in other means, by accepting the VPC peering connection and
* set up the route to the requester.
*
* ## Usage Example
*
*
* ```hcl
* module "peering-request" {
*   source = "github.com/elastic-infra/terraform-modules//aws/vpc-peering-requester-multiaccount?ref=v2.3.0"
*
*   enabled              = "true"
*   namespace            = "foo"
*   stage                = "dev"
*   name                 = "bar"
*   delimiter            = "-"
*   requester_vpc_id     = "vpc-12345678"
*   peer_owner_id        = "012345678901"
*   peer_vpc_id          = "vpc-0123456789abcdef"
*   peer_region          = "us-west-1"
*   peer_vpc_cidr_blocks = ["192.0.2.0/24"]
*   tags {
*     Environment = "development"
*   }
*
*   providers = {
*     aws = aws.us-east-1
*   }
* }
* ```
*/

locals {
  enabled = var.enabled == "true"
  count   = local.enabled ? 1 : 0
}

terraform {
  required_version = ">= 0.13"
}
