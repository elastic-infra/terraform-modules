output "json_map_encoded" {
  description = "JSON string encoded container definitions"
  value       = module.container_definition.json_map_encoded
}

output "json_map_object" {
  description = "JSON map encoded container definition"
  value       = module.container_definition.json_map_object
}
