# Yiro AWS Infrastructure

Terraform infrastructure for Yiro. The repository provides a highly available network foundation for deploying application workloads on AWS, while keeping environments isolated and infrastructure reusable.

The current implementation provisions the development network. Staging and production root modules are in place for the same module-based deployment model as the platform grows.

## Architecture

The development environment spans two Availability Zones and separates traffic into public, application, and data tiers:

```text
                              Internet
                                  |
                         Internet Gateway
                                  |
          +---------------------------------------+
          |             AWS VPC (/20)             |
          |                                       |
          |  AZ A                  AZ B           |
          |  public subnet          public subnet  |
          |                                       |
          |  application subnet     application   |
          |          \              subnet        |
          |           +--- Regional NAT Gateway   |
          |                                       |
          |  data subnet            data subnet   |
          +---------------------------------------+
```

- **Highly available network layout:** public, application, and data subnets are distributed across two distinct Availability Zones.
- **Controlled egress:** application subnets reach the internet through an AWS Regional NAT Gateway; AWS manages its IP addresses and AZ coverage.
- **Network isolation:** data subnets have no default internet route, and no subnet assigns public IP addresses automatically.
- **Reusable Terraform modules:** environment root modules compose shared modules without sharing Terraform state.
- **Remote state:** each environment uses a separate S3 backend and native S3 locking.

> The current network is the platform foundation. Application Load Balancers, security groups, compute, and data services have not yet been implemented.

## Repository layout

```text
.
├── environments/
│   ├── dev/                 # Active network deployment
│   ├── staging/             # Environment root module
│   └── prod/                # Environment root module
├── modules/
│   ├── network/             # VPC, subnets, routing, IGW, and Regional NAT
│   └── project-metadata/    # Common resource tags
├── docs/                    # Architecture, operations, and ADRs
└── .github/workflows/       # Terraform formatting and validation CI
```

## Environments

Each directory under `environments/` is an independent Terraform root module with its own state:

| Environment | Status | Current scope |
| --- | --- | --- |
| `dev` | Active | Two-AZ VPC and network tiers |
| `staging` | Scaffolded | Metadata and backend configuration |
| `prod` | Scaffolded | Metadata and backend configuration |

## Getting started

Prerequisites:

- Terraform `>= 1.10.0`
- AWS credentials with permissions appropriate for the selected environment

Configure and review the development environment:

```bash
cd environments/dev
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with the project name, AWS Region, and two AZs.
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

Review the plan carefully before applying it. Do not commit `terraform.tfvars`, Terraform state, plan files, or credentials.

## Configuration

`environments/dev/terraform.tfvars.example` documents the required inputs:

```hcl
project_name       = "my-project"
aws_region         = "us-east-1"
vpc_cidr           = "10.0.0.0/20"
availability_zones = ["us-east-1a", "us-east-1b"]
```

The network module requires exactly two distinct Availability Zones. Keep their order stable after an environment is deployed to prevent subnet CIDR reassignment.

## Validation and CI

GitHub Actions runs the following checks on pull requests and on pushes to `main`:

```bash
terraform fmt -check -recursive
terraform -chdir=environments/<environment> init -backend=false -input=false
terraform -chdir=environments/<environment> validate
```

Run `terraform plan` from the affected environment before proposing any infrastructure change.

## Documentation

- [Architecture](docs/architecture/README.md)
- [Development workflow](docs/development/README.md)
- [Terraform state operations](docs/operations/terraform-state.md)
- [Architecture decisions](docs/decisions/README.md)

## Roadmap

The network is designed to support future application components, including load balancing, security groups, compute, managed data services, observability, and DNS.
