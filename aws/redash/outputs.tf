output "lb_dns" {
  value       = aws_lb.redash.dns_name
  description = "The DNS name of LB"
}

output "lb_zone_id" {
  value       = aws_lb.redash.zone_id
  description = "The Zone ID of LB"
}

output "lb_arn" {
  value       = aws_lb.redash.arn
  description = "The ARN of LB"
}

output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.redash.arn
  description = "The ARN of ECS Cluster on which redash is running"
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.redash.name
  description = "The Name of ECS Cluster on which redash is running"
}

output "ecs_service_server_arn" {
  value       = aws_ecs_service.server.id
  description = "The ARN of ECS Service on which server is running"
}

output "ecs_service_server_name" {
  value       = aws_ecs_service.server.name
  description = "The Name of ECS Service on which server is running"
}

output "ecs_service_worker_arn" {
  value       = aws_ecs_service.worker.id
  description = "The ARN of ECS Service on which worker is running"
}

output "ecs_service_worker_name" {
  value       = aws_ecs_service.worker.name
  description = "The Name of ECS Service on which worker is running"
}
