/**
* ## Information
*
* This module creates ECS cluster and Task Definition for Socks5 proxy.
*
* ### Usage
*
* ```hcl
* module "bastion" {
*   source = "github.com/elastic-infra/terraform-modules//aws/fargate-bastion?ref=v6.4.0"
*
*   prefix = "production"
*
*   ecs = {
*     subnets = module.vpc.private_subnets
*     security_groups = [
*       module.vpc.default_security_group_id,
*     ]
*   }
* }
*
* resource "local_file" "proxy_command" {
*   content  = module.bastion.command
*   filename = "${path.root}/start_port_forwarding_to_socks_server.sh"
*
*   file_permission = "0755"
* }
* ```
*
*/
