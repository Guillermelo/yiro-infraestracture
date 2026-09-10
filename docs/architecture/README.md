# Architecture

## Current structure

- `environments/`: independent Terraform root modules for `dev`, `staging`, and `prod`.
- `modules/`: reusable Terraform modules; they do not configure a backend or maintain their own state.
- `docs/`: technical and operational documentation.

Each environment maintains an independent remote state file in S3. See [Terraform state operations](../operations/terraform-state.md).

As components are added, document their diagrams, dependencies, network boundaries, data flows, and owners here.

## Development network

`environments/dev` composes `modules/network` and receives its tags from `project_metadata`. It does not use Kubernetes. An ALB, security groups, and the application backend have not yet been implemented.

- IPv4 `/20` VPC, two distinct Availability Zones, and six `/24` subnets.
- Public subnets: offsets 0 and 1, with a default route to the Internet Gateway, reserved for the future ALB.
- Application subnets: offsets 2 and 3, using a shared route table with egress through the Regional NAT Gateway.
- Data subnets: offsets 4 and 5, with only a local route; access isolation requires security groups.
- Automatic public Regional NAT Gateway, without a Terraform-managed subnet or Elastic IP.
- Instances do not receive public IP addresses automatically.

The AWS provider must be `>= 6.24.0, < 7.0.0`. Development requires Terraform `>= 1.10.0` for the configured native S3 locking. Region, CIDR, and Availability Zones are configured per environment; see `environments/dev/terraform.tfvars.example`. Keep the Availability Zone order stable to avoid subnet CIDR reassignment.

A Regional NAT Gateway can take up to 60 minutes to expand to a new Availability Zone; during that interval, it may process traffic in another Availability Zone. A single ID does not mean the cost of a single zonal NAT gateway: review Availability Zone, processing, and IPv4 charges. For fixed IP allowlists, evaluate manual mode before deployment.

Do not apply changes without reviewing the plan. If zonal NAT gateways already exist, changing routes can interrupt connections and change egress IP addresses; schedule a maintenance window.

Reference: [AWS Regional NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/nat-gateways-regional.html).
