# Terraform remote state

## Configuration

State is stored in the `yiro-terraform-state-741793812640` S3 bucket in the `sa-east-1` Region.

| Environment | S3 key |
| --- | --- |
| `dev` | `dev/terraform.tfstate` |
| `staging` | `staging/terraform.tfstate` |
| `prod` | `prod/terraform.tfstate` |

Each root module has its own `backend.tf`. The backend uses S3 encryption (`AES256`) and native S3 locking (`use_lockfile = true`).

## Bucket protection

The bucket was created outside Terraform during bootstrap because a backend must exist before `terraform init` can run. It has:

- versioning enabled;
- public-access blocking enabled;
- Object Ownership set to `BucketOwnerEnforced`;
- default SSE-S3 encryption (`AES256`).

## Usage

With valid AWS credentials and permissions for the bucket:

```bash
cd environments/dev
terraform init
terraform plan
```

Terraform obtains credentials through the standard AWS provider chain, for example `AWS_PROFILE`, environment variables, SSO, or an IAM role. The repository sets `AWS_PROFILE=default` in `.envrc`.

## Recovery and maintenance

- Do not manually edit or delete state objects.
- Versioning allows recovery of a previous version after an accidental change. Review the history first and restore only with explicit review.
- If a lock file remains after an interruption, verify that no other Terraform operation is running before using `terraform force-unlock`.
- Follow least privilege: grant read/write access only to the required state prefixes and permissions to manage the `.tflock` file.
