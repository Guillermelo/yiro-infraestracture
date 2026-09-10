output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_ids" {
  description = "Public subnets for the ALB."
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_app_subnet_ids" {
  description = "Private backend subnets."
  value       = [for subnet in aws_subnet.private_app : subnet.id]
}

output "private_data_subnet_ids" {
  description = "Isolated data subnets."
  value       = [for subnet in aws_subnet.private_data : subnet.id]
}

output "availability_zones" {
  description = "Selected Availability Zones."
  value       = var.availability_zones
}

output "regional_nat_gateway_id" {
  description = "Regional NAT Gateway ID."
  value       = aws_nat_gateway.this.id
}
