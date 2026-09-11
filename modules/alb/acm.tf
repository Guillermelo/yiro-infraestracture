resource "aws_acm_certificate" "this" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  # terraform code if this resouce need to update
  # first create the new one then destroy
  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
