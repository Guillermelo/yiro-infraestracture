output "name_prefix" {
  description = "Prefijo que deben usar los recursos de este entorno."
  value       = module.project_metadata.name_prefix
}

output "tags" {
  description = "Etiquetas estándar para este entorno."
  value       = module.project_metadata.tags
}
