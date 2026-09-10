# Desarrollo de infraestructura

1. Trabaja en el directorio del entorno afectado (`environments/dev`, `environments/staging` o `environments/prod`).
2. Mantén valores locales o sensibles en `terraform.tfvars` o mediante `TF_VAR_*`; no los versionas.
3. Antes de proponer cambios de infraestructura, ejecuta:

   ```bash
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan
   ```

4. Revisa el plan antes de aplicar. Los recursos compartidos deben quedar documentados en `docs/architecture/` y las decisiones significativas en `docs/decisions/`.
