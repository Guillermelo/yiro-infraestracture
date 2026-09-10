# Documentación

Este directorio centraliza la documentación mantenida del proyecto. Cada documento debe describir el estado actual, incluir enlaces a material relacionado y evitar secretos, credenciales o valores de `*.tfvars`.

## Índice

- [Arquitectura](architecture/README.md): estructura, límites y decisiones técnicas del sistema.
- [Desarrollo](development/README.md): convenciones para modificar y validar infraestructura.
- [Operaciones](operations/terraform-state.md): backend remoto, acceso y recuperación del estado Terraform.
- [Decisiones](decisions/README.md): registro de decisiones de arquitectura (ADR).

## Convención para documentos nuevos

Ubica cada documento en la categoría correspondiente y usa nombres en minúsculas con guiones. Para decisiones relevantes, crea un ADR en `decisions/` con el formato `NNNN-titulo-corto.md` y enlázalo desde su índice.
