# project-metadata

Módulo sin proveedor que centraliza un prefijo de nombres y etiquetas comunes. Úsalo como ejemplo para módulos de red, cómputo, bases de datos u otros recursos.

## Entradas

- `project_name`: nombre corto del proyecto.
- `environment`: `dev`, `staging` o `prod`.
- `additional_tags`: etiquetas opcionales.

## Salidas

- `name_prefix`: `<project_name>-<environment>`.
- `tags`: etiquetas estándar listas para pasar a recursos compatibles.
