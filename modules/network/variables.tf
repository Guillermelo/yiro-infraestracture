variable "project_name" {
  description = "Short project name."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition = contains(["dev", "staging", "prod"],
    var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" {
  description = "VPC IPv4 CIDR."
  type        = string
  default     = "10.0.0.0/20"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr)) && can(regex("/20$", var.vpc_cidr))
    error_message = "vpc_cidr must be an IPv4 /20 CIDR to create /24 subnets."
  }
}

variable "availability_zones" {
  description = "VPC Availability Zones."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2 && length(distinct(var.availability_zones)) == 2
    error_message = "Exactly two distinct Availability Zones are required."
  }
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
