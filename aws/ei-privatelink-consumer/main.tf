locals {
  vpce_service_name = {
    "ap-northeast-1" = "com.amazonaws.vpce.ap-northeast-1.vpce-svc-0bbba1a5d2095d2c3"
    "ap-southeast-1" = "com.amazonaws.vpce.ap-southeast-1.vpce-svc-04e0492e238602578"
    "ap-east-1"      = "com.amazonaws.vpce.ap-east-1.vpce-svc-0f51fd6fe1406f882"
    "us-east-1"      = "com.amazonaws.vpce.us-east-1.vpce-svc-0d87332b34a7a49dc"
    "eu-west-2"      = "com.amazonaws.vpce.eu-west-2.vpce-svc-095f356e082bbf579"
    "eu-west-3"      = "com.amazonaws.vpce.eu-west-3.vpce-svc-035a632822c04307a"
  }
  ei_sg_ids = data.aws_region.current.name == "ap-northeast-1" ? [var.ei_sg_ids] : []
  ei_cidrs  = data.aws_region.current.name == "ap-northeast-1" ? [] : [var.ei_cidrs]
}

data "aws_region" "current" {}

resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = local.vpce_service_name[data.aws_region.current.name]
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

  dynamic "ingress" {
    for_each = local.ei_sg_ids

    content {
      from_port       = -1
      to_port         = -1
      protocol        = "icmp"
      security_groups = ingress.value
    }
  }

  dynamic "ingress" {
    for_each = local.ei_sg_ids

    content {
      from_port       = 22
      to_port         = 22
      protocol        = "tcp"
      security_groups = ingress.value
    }
  }

  dynamic "ingress" {
    for_each = local.ei_cidrs

    content {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_blocks = ingress.value
    }
  }

  dynamic "ingress" {
    for_each = local.ei_cidrs

    content {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }
}
