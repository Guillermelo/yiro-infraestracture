variable "aws_region" {
  description = "AWS deployment region."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC IPv4 /20 CIDR."
  type        = string
}

variable "availability_zones" {
  description = "Two AZs in the selected region; keep their order stable."
  type        = list(string)
}

variable "project_name" {
  description = "Short project name."
  type        = string
}

variable "additional_tags" {
  description = "Additional environment resource tags."
  type        = map(string)
  default     = {}
}
