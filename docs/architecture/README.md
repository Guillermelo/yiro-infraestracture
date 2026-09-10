# Arquitectura

## Estructura actual

- `environments/`: root modules de Terraform independientes para `dev`, `staging` y `prod`.
- `modules/`: módulos Terraform reutilizables; no configuran backend ni mantienen estado propio.
- `docs/`: documentación técnica y operativa.

Cada entorno mantiene un archivo de estado remoto independiente en S3. Consulta [Operaciones: estado Terraform](../operations/terraform-state.md).

A medida que se incorporen componentes, documentar aquí sus diagramas, dependencias, límites de red, flujos de datos y responsables.

## Red de dev

`environments/dev` integra `modules/network` y recibe las etiquetas de
`project_metadata`. No utiliza Kubernetes. ALB, security groups y backend aún
no están implementados.

- VPC IPv4 `/20`, dos AZ distintas y seis subnets `/24`.
- Públicas: offsets 0 y 1, ruta por defecto al Internet Gateway, para el futuro ALB.
- Aplicación: offsets 2 y 3, tabla compartida con salida al Regional NAT Gateway.
- Datos: offsets 4 y 5, solo ruta local; el aislamiento de acceso requiere security groups.
- RNAT público automático, sin subnet ni EIP administrada por Terraform.
- Las instancias no reciben IP pública automáticamente.

El proveedor AWS requiere versión >= 6.24.0 y < 7.0.0. Dev requiere Terraform
>= 1.10.0 por el bloqueo nativo S3 ya configurado. La región, CIDR y AZ se
configuran por entorno; ver `environments/dev/terraform.tfvars.example`.
Mantener estable el orden de las AZ evita reasignar CIDRs.

RNAT puede tardar hasta 60 minutos en expandirse a una nueva AZ; durante ese
intervalo puede procesar tráfico en otra AZ. Un único ID no implica el costo
de un solo NAT zonal: revisar cargos por AZ, procesamiento e IPv4. Para IPs
fijas en allowlists, evaluar modo manual antes de desplegar.

No se debe aplicar sin revisar el plan. Si ya existen NAT zonales, cambiar
las rutas puede interrumpir conexiones y cambiar IPs de salida; planificar
una ventana de mantenimiento.

Referencia: [AWS Regional NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateways-regional.html).
