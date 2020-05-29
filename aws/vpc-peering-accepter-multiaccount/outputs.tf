output "accepting_vpc_peering" {
  value       = aws_vpc_peering_connection_accepter.accepter.id
  description = "Accepting VPC peering ID"
}

output "vpc_peering_status" {
  value       = aws_vpc_peering_connection_accepter.accepter.accept_status
  description = "Status of accepting VPC peering"
}
