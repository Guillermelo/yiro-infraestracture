variable "project_name" {
  description = "Nombre corto del proyecto."
  type        = string
}

variable "additional_tags" {
  description = "Etiquetas adicionales para todos los recursos del entorno."
  type        = map(string)
  default     = {}
}
