locals {
  vpce_service_name = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0bbba1a5d2095d2c3"
  ei_sg_id          = "sg-3845ff5c"
}

resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = local.vpce_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.subnet_ids
  security_group_ids  = [aws_security_group.this.id]
  private_dns_enabled = var.private_dns_enabled
  tags = {
    Name = "Elastic Infra Common Service"
  }
}

resource "aws_security_group" "this" {
  name   = "elastic-infra-common-service"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ei_managed.id]
  }
}

resource "aws_security_group" "ei_managed" {
  name   = "ei-managed"
  vpc_id = var.vpc_id

  ingress {
    from_port       = -1
    to_port         = -1
    protocol        = "icmp"
    security_groups = [local.ei_sg_id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [local.ei_sg_id]
  }
}
