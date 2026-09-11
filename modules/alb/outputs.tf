output "certificate_validation_records" {
  description = "DNS records required for ACM validation."
  value = {
    for option in aws_acm_certificate.this.domain_validation_options :
    option.domain_name => {
      name  = option.resource_record_name
      type  = option.resource_record_type
      value = option.resource_record_value
    }
  }
}

output "arn" {
  description = "ALB ARN."
  value       = aws_lb.this.arn
}

output "dns_name" {
  description = "ALB DNS name."
  value       = aws_lb.this.dns_name
}

output "target_group_arns" {
  description = "Target Group ARNs by service."
  value = {
    backend = aws_lb_target_group.backend.arn
    sockets = aws_lb_target_group.sockets.arn
  }
}

output "security_group_id" {
  description = "ALB security group ID."
  value       = aws_security_group.alb.id
}
