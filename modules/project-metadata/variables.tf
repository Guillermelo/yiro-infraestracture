variable "project_name" {
  description = "Nombre corto y estable del proyecto."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name solo puede contener letras minúsculas, números y guiones."
  }
}

variable "environment" {
  description = "Entorno al que pertenecen los recursos."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment debe ser dev, staging o prod."
  }
}

variable "additional_tags" {
  description = "Etiquetas adicionales para combinar con las etiquetas estándar."
  type        = map(string)
  default     = {}
}
