module "project_metadata" {
  source = "../../modules/project-metadata"

  project_name    = var.project_name
  environment     = "dev"
  additional_tags = var.additional_tags
}

module "network" {
  source = "../../modules/network"

  project_name       = var.project_name
  environment        = "dev"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = module.project_metadata.tags
}

module "alb" {
  source = "../../modules/alb"

  domain_name = var.alb_domain_name

  name_prefix       = module.project_metadata.name_prefix
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids

  backend_health_check_path = var.backend_health_check_path
  sockets_health_check_path = var.sockets_health_check_path

  tags = module.project_metadata.tags
}

module "backend_asg" {
  source = "../../modules/app-asg"
}

module "sockets_asg" {
  source = "../../modules/app-asg"
}
