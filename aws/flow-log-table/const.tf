locals {
  # Versions mapping for Athena table
  # Larger version includes all previous versions
  #
  # ```
  # column_versions = {
  #   VER = list(object({
  #     name = string
  #     type = string
  #   }))
  # }
  # ```
  column_by_version = {
    v2 = [
      {
        name = "version"
        type = "string"
      },
      {
        name = "account_id"
        type = "string"
      },
      {
        name = "interface_id"
        type = "string"
      },
      {
        name = "srcaddr"
        type = "string"
      },
      {
        name = "dstaddr"
        type = "string"
      },
      {
        name = "srcport"
        type = "int"
      },
      {
        name = "dstport"
        type = "int"
      },
      {
        name = "protocol"
        type = "bigint"
      },
      {
        name = "packets"
        type = "bigint"
      },
      {
        name = "bytes"
        type = "bigint"
      },
      {
        name = "start"
        type = "bigint"
      },
      {
        name = "end"
        type = "bigint"
      },
      {
        name = "action"
        type = "string"
      },
      {
        name = "log_status"
        type = "string"
      },
    ]
    v3 = [
      {
        name = "vpc_id"
        type = "string"
      },
      {
        name = "subnet_id"
        type = "string"
      },
      {
        name = "instance_id"
        type = "string"
      },
      {
        name = "tcp_flags"
        type = "int"
      },
      {
        name = "type"
        type = "int"
      },
      {
        name = "pkt_srcaddr"
        type = "string"
      },
      {
        name = "pkt_dstaddr"
        type = "string"
      },
    ]
    v4 = [
      {
        name = "region"
        type = "string"
      },
      {
        name = "az_id"
        type = "string"
      },
      {
        name = "sublocation_type"
        type = "string"
      },
      {
        name = "sublocation_id"
        type = "string"
      },
    ]
    v5 = [
      {
        name = "pkt_src_aws_service"
        type = "string"
      },
      {
        name = "pkt_dst_aws_service"
        type = "string"
      },
      {
        name = "flow_direction"
        type = "string"
      },
      {
        name = "traffic_path"
        type = "string"
      },
    ]
    v7 = [
      {
        name = "ecs_cluster_arn"
        type = "string"
      },
      {
        name = "ecs_cluster_name"
        type = "string"
      },
      {
        name = "ecs_container_instance_arn"
        type = "string"
      },
      {
        name = "ecs_container_instance_id"
        type = "string"
      },
      {
        name = "ecs_container_id"
        type = "string"
      },
      {
        name = "ecs_second_container_id"
        type = "string"
      },
      {
        name = "ecs_service_name"
        type = "string"
      },
      {
        name = "ecs_task_definition_arn"
        type = "string"
      },
      {
        name = "ecs_task_arn"
        type = "string"
      },
      {
        name = "ecs_task_id"
        type = "string"
      },
    ]
    v8 = [
      {
        name = "reject_reason"
        type = "string"
      },
    ]
  }

  columns_for_versions = {
    for ver, _ in local.column_by_version :
    ver => flatten(concat([
      for ver2, l in local.column_by_version : l if replace(ver2, "v", "") <= replace(ver, "v", "")
    ]))
  }
}
