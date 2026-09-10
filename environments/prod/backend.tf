terraform {
  backend "s3" {
    bucket       = "yiro-terraform-state-741793812640"
    key          = "prod/terraform.tfstate"
    region       = "sa-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
