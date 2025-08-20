/**
* ## Information
*
* Manages an RDS DB Reserved Instance
*
* ### Usage
*
* ```hcl
* module "rds_reserved_instance" {
*   source = "github.com/elastic-infra/terraform-modules//aws/rds-reserved-instance?ref=v8.2.0"
*
*   product_description = "mysql"
*   db_instance_class   = "db.t2.micro"
*   instance_count      = 1
* }
* ```
*
*/

data "aws_rds_reserved_instance_offering" "this" {
  db_instance_class   = var.db_instance_class
  duration            = var.duration
  multi_az            = var.multi_az
  offering_type       = var.offering_type
  product_description = var.product_description
}

resource "aws_rds_reserved_instance" "this" {
  offering_id    = data.aws_rds_reserved_instance_offering.this.offering_id
  reservation_id = var.reservation_id
  instance_count = var.instance_count
}
