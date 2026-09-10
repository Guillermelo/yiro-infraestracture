# Estado remoto de Terraform

## Configuración

El estado se almacena en el bucket S3 `yiro-terraform-state-741793812640`, en la región `sa-east-1`.

| Entorno | Clave S3 |
| --- | --- |
| `dev` | `dev/terraform.tfstate` |
| `staging` | `staging/terraform.tfstate` |
| `prod` | `prod/terraform.tfstate` |

Cada root module tiene su propio `backend.tf`. El backend usa cifrado S3 (`AES256`) y bloqueo nativo de S3 (`use_lockfile = true`).

## Protección del bucket

El bucket fue creado fuera de Terraform (bootstrap), porque un backend debe existir antes de ejecutar `terraform init`. Tiene:

- versionado habilitado;
- bloqueo de acceso público habilitado;
- Object Ownership configurado como `BucketOwnerEnforced`;
- cifrado por defecto SSE-S3 (`AES256`).

## Uso

Con credenciales AWS válidas y permisos para el bucket:

```bash
cd environments/dev
terraform init
terraform plan
```

Terraform obtiene las credenciales mediante la cadena estándar de AWS, por ejemplo `AWS_PROFILE`, variables de entorno, SSO o un rol IAM. El repositorio define `AWS_PROFILE=default` en `.envrc`.

## Recuperación y mantenimiento

- No edites ni elimines objetos de estado manualmente.
- El versionado permite recuperar una versión anterior ante una modificación accidental. Revisa primero el historial y restaura solo con revisión explícita.
- Si queda un archivo de bloqueo después de una interrupción, verifica que no haya otra operación Terraform en curso antes de usar `terraform force-unlock`.
- Conserva permisos mínimos: lectura/escritura de los prefijos de estado necesarios y permisos para administrar el archivo `.tflock`.
