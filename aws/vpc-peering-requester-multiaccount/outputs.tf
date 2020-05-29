output "requester_connection_id" {
  value       = join("", aws_vpc_peering_connection.requester.*.id)
  description = "Requester VPC peering connection ID"
}

output "requester_accept_status" {
  value       = join("", aws_vpc_peering_connection.requester.*.accept_status)
  description = "Requester VPC peering connection request status"
}
