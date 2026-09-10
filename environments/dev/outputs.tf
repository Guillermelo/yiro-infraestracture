output "vpc_id" {
  description = "Environment VPC ID."
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnets for the ALB."
  value       = module.network.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "Private backend subnets."
  value       = module.network.private_app_subnet_ids
}

output "private_data_subnet_ids" {
  description = "Isolated data subnets."
  value       = module.network.private_data_subnet_ids
}

output "regional_nat_gateway_id" {
  description = "Regional NAT Gateway ID."
  value       = module.network.regional_nat_gateway_id
}

output "name_prefix" {
  description = "Environment resource name prefix."
  value       = module.project_metadata.name_prefix
}

output "tags" {
  description = "Standard environment tags."
  value       = module.project_metadata.tags
}
