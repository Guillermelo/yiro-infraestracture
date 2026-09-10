# Documentation

This directory contains the maintained project documentation. Every document must describe the current state, link to related material, and exclude secrets, credentials, and values from `*.tfvars` files.

## Index

- [Architecture](architecture/README.md): system structure, boundaries, and technical decisions.
- [Development](development/README.md): conventions for changing and validating infrastructure.
- [Operations](operations/terraform-state.md): remote backend, access, and Terraform state recovery.
- [Decisions](decisions/README.md): architecture decision record (ADR) log.

## Convention for new documents

Place each document in the appropriate category and use lowercase, hyphenated filenames. For significant decisions, create an ADR under `decisions/` using the `NNNN-short-title.md` format and link to it from that directory's index.
