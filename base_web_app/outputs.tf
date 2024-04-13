output "ALB_public_dns" {
  value       = "http://${aws_lb.nginx.dns_name}"
  description = "ALB public DNS"
}

output "aws_instances_public_ip" {
  value       = aws_instance.nginx_instance[*].public_ip
  description = "Public IP for instance"
}
