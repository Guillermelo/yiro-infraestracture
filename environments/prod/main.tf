module "project_metadata" {
  source = "../../modules/project-metadata"

  project_name    = var.project_name
  environment     = "prod"
  additional_tags = var.additional_tags
}

# Añade aquí los módulos de infraestructura para prod.
# Ejemplo:
# module "network" {
#   source = "../../modules/network"
#   # ...
# }
