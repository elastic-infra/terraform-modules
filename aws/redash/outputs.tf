output "lb_dns" {
  value       = aws_lb.redash.dns_name
  description = "The DNS name of LB"
}

output "lb_zone_id" {
  value       = aws_lb.redash.zone_id
  description = "The Zone ID of LB"
}
