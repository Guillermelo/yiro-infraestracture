# Infraestructura Terraform

Boilerplate para organizar infraestructura por entorno y módulos reutilizables.

## Estructura objetivo

```text
aws-ride-hailing-infra/
├── README.md
├── .gitignore
├── Makefile
├── versions.tf
│
├── modules/                         # Bloques reutilizables, sin valores de prod hardcodeados
│   ├── network/
│   │   ├── main.tf                   # VPC, subnets, IGW, NAT, route tables
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── versions.tf
│   │
│   ├── security/
│   │   ├── main.tf                   # SG CloudFront/ALB, backend, socket, Redis
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── alb/
│   │   ├── main.tf                   # ALB, listeners, TG backend/socket, rules por path
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── compute/
│   │   ├── main.tf                   # Launch templates y ASG
│   │   ├── user_data.sh.tftpl
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── cloudfront/
│   │   ├── main.tf                   # Distribution, WAF association, origins/behaviors
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── redis/
│   │   ├── main.tf                   # ElastiCache replication group/subnet group
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── dns/
│   │   ├── main.tf                   # Route 53, ACM validation records
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── monitoring/
│   │   ├── main.tf                   # CloudWatch log groups, alarms, dashboards
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   └── iam/
│       ├── main.tf                   # EC2 roles/profiles, GitHub OIDC roles
│       ├── policies.tf
│       ├── variables.tf
│       └── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── backend.tf                # Remote state: bucket/key/region
│   │   ├── providers.tf
│   │   ├── main.tf                   # Ensambla los módulos
│   │   ├── variables.tf
│   │   ├── terraform.tfvars.example
│   │   └── outputs.tf
│   │
│   └── prod/
│       ├── backend.tf
│       ├── providers.tf
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars.example
│       └── outputs.tf
│
├── policies/                         # JSON solo si una policy se vuelve muy grande
│   ├── ec2-secrets-read.json
│   └── github-deploy.json
│
├── scripts/
│   ├── validate.sh
│   └── plan.sh
│
└── .github/
    └── workflows/
        ├── terraform-plan.yml
        └── terraform-apply.yml
```

> Esta es la estructura objetivo. El repositorio actual la irá incorporando gradualmente; por ahora también existe el entorno `staging`.

## Inicio rápido

1. Elige un entorno, por ejemplo `environments/dev`.
2. Crea tus variables locales sin versionarlas:

   ```bash
   cd environments/dev
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Añade el proveedor y los recursos que necesites. Los entornos ya usan el backend remoto S3; consulta la [documentación del estado](docs/operations/terraform-state.md).
4. Inicializa y revisa los cambios:

   ```bash
   terraform init
   terraform fmt -recursive
   terraform validate
   terraform plan
   ```

> No compartas archivos `*.tfvars`, estados ni credenciales. Define secretos mediante el gestor de secretos de tu proveedor o variables de entorno (`TF_VAR_*`).

## Documentación

Consulta el [índice de documentación](docs/README.md) para arquitectura, desarrollo, operaciones y decisiones técnicas.

## Convenciones

- Cada directorio bajo `environments/` es un root module y conserva un estado separado.
- Reutiliza recursos mediante `modules/`; un módulo no debe incluir configuración de backend.
- Duplica `modules/project-metadata` como base para módulos nuevos y documenta sus variables y outputs.
- Mantén los valores específicos de cada entorno en `terraform.tfvars` (ignorado por Git); el archivo `terraform.tfvars.example` solo contiene valores de muestra.

## Mejoras futuras

- Incorporar un firewall para el tráfico saliente a través del NAT Gateway, con una lista permitida de dominios específicos, para reforzar la seguridad.
