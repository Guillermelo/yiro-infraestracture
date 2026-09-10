output "name_prefix" {
  description = "Prefijo consistente para nombres de recursos."
  value       = local.name_prefix
}

output "tags" {
  description = "Etiquetas estándar combinadas con las etiquetas adicionales."
  value       = local.tags
}
