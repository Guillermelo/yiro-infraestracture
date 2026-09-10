# Infrastructure development

1. Work in the affected environment directory (`environments/dev`, `environments/staging`, or `environments/prod`).
2. Keep local or sensitive values in `terraform.tfvars` or through `TF_VAR_*`; do not commit them.
3. Before proposing infrastructure changes, run:

   ```bash
   terraform init
   terraform fmt -check
   terraform validate
   terraform plan
   ```

4. Review the plan before applying it. Document shared resources in `docs/architecture/` and significant decisions in `docs/decisions/`.
