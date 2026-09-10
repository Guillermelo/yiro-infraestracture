module "project_metadata" {
  source = "../../modules/project-metadata"

  project_name    = var.project_name
  environment     = "dev"
  additional_tags = var.additional_tags
}

# Add infrastructure modules for dev here.
# Example:
# module "network" {
#   source = "../../modules/network"
#   # ...
# }

module "network" {
  source = "../../modules/network"

  project_name       = var.project_name
  environment        = "dev"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = module.project_metadata.tags
}
